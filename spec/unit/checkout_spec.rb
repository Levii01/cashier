# frozen_string_literal: true

RSpec.describe Checkout do
  let(:basket) { instance_double(Basket) }
  let(:pricing_rule) { instance_double(PricingRules::BulkDiscountRule) }
  let(:checkout) { described_class.new([pricing_rule]) }

  before { allow(Basket).to receive(:new).and_return(basket) }

  describe '#initialize' do
    it 'starts with empty basket and zeroed totals' do
      expect(checkout.basket).to eq(basket)
      expect(checkout.subtotal).to eq(0)
      expect(checkout.discount).to eq(0)
      expect(checkout.total).to eq(0)
    end
  end

  describe '#scan' do
    let(:product) { instance_double(Product) }

    before do
      allow(product).to receive_messages(
        price_to_s: '$4.50',
        code: 'SR1',
        name: 'Strawberries'
      )
    end

    it 'delegates adding a product to basket' do
      allow(basket).to receive(:add)
      checkout.scan(product)
      expect(basket).to have_received(:add).with(product)
    end
  end

  describe '#calculete_total' do
    subject(:calculete_total) { checkout.calculete_total }

    let(:basket_item) { instance_double(BasketItem) }
    let(:items) { { 'X' => basket_item } }

    before do
      allow(basket).to receive_messages(
        items:,
        items_total_price: 1000,
        items_discounted_price: 800
      )

      allow(basket_item).to receive(:reset_discount)
      allow(pricing_rule).to receive(:applies_to?).and_return(true)
      allow(pricing_rule).to receive(:apply).with(basket_item)
    end

    it 'resets discounts on basket items' do
      calculete_total
      expect(basket_item).to have_received(:reset_discount)
    end

    it 'applies rules that match the basket item' do
      calculete_total
      expect(pricing_rule).to have_received(:applies_to?).with(basket_item)
      expect(pricing_rule).to have_received(:apply).with(basket_item)
    end

    it 'updates subtotal, discount and total' do
      calculete_total
      expect(checkout.subtotal).to eq(1000)
      expect(checkout.total).to eq(800)
      expect(checkout.discount).to eq(200)
    end
  end

  describe '#summary' do
    before do
      checkout.instance_variable_set(:@subtotal, 2000)
      checkout.instance_variable_set(:@discount, 500)
      checkout.instance_variable_set(:@total, 1500)
    end

    it 'prints formatted output' do
      expect { checkout.summary }.to output(
        "Subtotal: £20.0\nDiscount: £5.0\nTotal:    £15.0\n"
      ).to_stdout
    end
  end
end
