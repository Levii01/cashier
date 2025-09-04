# frozen_string_literal: true

RSpec.describe Basket do
  let(:basket) { described_class.new }
  let(:product_tea) { Product.new(code: 'GR1', name: 'Green Tea', price: 311) }
  let(:product_fruit) { Product.new(code: 'SR1', name: 'Strawberries', price: 500) }

  describe '#initialize' do
    it { expect(basket).to have_attributes(items: {}) }
  end

  describe '#add' do
    subject(:add) { basket.add(product_tea) }

    context 'when basket is empty' do
      it 'adds a product to the basket' do
        add
        expect(basket.items.size).to eq(1)
        expect(basket.items[product_tea.code]).to have_attributes(product: product_tea, quantity: 1)
      end
    end

    context 'when this product is already in the basket' do
      before { basket.add(product_tea) }

      it 'increments quantity if same product is added again' do
        add
        expect(basket.items.size).to eq(1)
        expect(basket.items[product_tea.code]).to have_attributes(product: product_tea, quantity: 2)
      end
    end

    context 'with different product is already in the basket' do
      before { basket.add(product_fruit) }

      it 'adds different products as separate BasketItems' do
        add
        expect(basket.items.size).to eq(2)
        expect(basket.items[product_tea.code]).to have_attributes(product: product_tea, quantity: 1)
        expect(basket.items[product_fruit.code]).to have_attributes(product: product_fruit, quantity: 1)
      end
    end

    it 'raises a validation error if product is nil' do
      expect { basket.add(nil) }.to raise_error(ValidationError, 'Validation failed: Product must be provided')
    end
  end

  describe '#items' do
    subject(:items) { basket.items }

    before do
      basket.add(product_fruit)
      basket.add(product_tea)
    end

    it 'returns all basket items' do
      expect(items.values.map(&:product)).to include(product_fruit, product_tea)
      expect(items.values.map(&:quantity)).to eq([1, 1])
    end
  end

  describe '#empty?' do
    context 'when basket is empty' do
      it { expect(basket.empty?).to be true }
    end

    context 'when basket is not empty' do
      before { basket.add(product_tea) }

      it { expect(basket.empty?).to be false }
    end
  end

  describe '#items_total_price' do
    subject(:total_price) { basket.items_total_price }

    context 'with multiple items' do
      before do
        basket.add(product_tea)
        basket.add(product_fruit)
      end

      it 'returns the sum of total prices of all basket items' do
        expect(total_price).to eq(311 + 500)
      end
    end

    context 'with multiple quantities of same product' do
      before do
        3.times { basket.add(product_tea) } # 3 * 311 = 933
        basket.add(product_fruit) # 500
      end

      it 'calculates total price correctly considering quantity' do
        expect(total_price).to eq(933 + 500)
      end
    end
  end

  describe '#items_discounted_price' do
    subject(:discounted_price) { basket.items_discounted_price }

    before do
      basket.add(product_tea)
      basket.add(product_fruit)

      # dodajemy ręcznie zniżkę, żeby przetestować sumowanie
      basket.items[product_tea.code].set_discount(100, instance_double(PricingRules::BulkDiscountRule))
      basket.items[product_fruit.code].set_discount(200, instance_double(PricingRules::BulkDiscountRule))
    end

    it 'returns the sum of discounted prices of all basket items' do
      expect(discounted_price).to eq(211 + 300)
    end
  end
end
