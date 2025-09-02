# frozen_string_literal: true

RSpec.describe Basket do
  let(:basket) { described_class.new }
  let(:product_tea) { Product.new(code: 'GR1', name: 'Green Tea', price: 3.11) }
  let(:product_fruit) { Product.new(code: 'SR1', name: 'Strawberries', price: 5.00) }

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
end
