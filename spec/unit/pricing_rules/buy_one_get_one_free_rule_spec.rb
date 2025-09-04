# frozen_string_literal: true

RSpec.describe PricingRules::BuyOneGetOneFreeRule do
  let(:product) { Product.new(code: 'GR1', name: 'Green Tea', price: 311) }
  let(:rule)    { described_class.new(product_code: 'GR1') }
  let(:quantity) { 2 }

  describe '#applies_to?' do
    subject(:applies_to?) { rule.applies_to?(basket_item) }

    let(:basket_item) { BasketItem.new(product:, quantity:) }

    context 'with 2 quantities of product' do
      it 'returns true when product code matches and quantity >= 2' do
        expect(applies_to?).to be true
      end
    end

    context 'with 1 quantity of product' do
      let(:quantity) { 1 }

      it 'returns false when product code matches but quantity < 2' do
        expect(applies_to?).to be false
      end
    end

    context 'with 2 quantity of other product' do
      let(:product) { Product.new(code: 'SR1', name: 'Strawberries', price: 500) }

      it 'returns false when product code does not match' do
        expect(applies_to?).to be false
      end
    end
  end

  describe '#apply' do
    subject(:apply) { rule.apply(basket_item) }

    let(:basket_item) { BasketItem.new(product:, quantity:) }
    let(:quantity) { 2 }

    context 'when basket item qualifies for BOGOF' do
      context 'with 2 quantities of product' do
        let(:quantity) { 2 }

        it 'applies discount correctly for 1 items' do
          apply

          expect(basket_item.total_price).to eq(622)
          expect(basket_item.discount).to eq(311)
          expect(basket_item.discounted_price).to eq(311)
        end
      end

      context 'with 3 quantities of product' do
        let(:quantity) { 3 }

        it 'applies discount correctly for 1 items' do
          apply
          expect(basket_item.total_price).to eq(933)
          expect(basket_item.discount).to eq(311)
          expect(basket_item.discounted_price).to eq(622)
        end
      end

      context 'with 22 quantities of product' do
        let(:quantity) { 22 }

        it 'applies discount correctly for 11 items' do
          apply
          expect(basket_item.total_price).to eq(6842)
          expect(basket_item.discount).to eq(3421)
          expect(basket_item.discounted_price).to eq(3421)
        end
      end
    end

    context 'when basket item does not qualify' do
      context 'with 1 quantitiy of product' do
        let(:quantity) { 1 }

        it 'does not apply discount if quantity < 2 and returns StandardError' do
          expect { apply }.to raise_error(StandardError, /cannot be applied/)
          expect(basket_item.total_price).to eq(311)
          expect(basket_item.discount).to eq(0)
          expect(basket_item.discounted_price).to eq(311)
        end
      end

      context 'with 1 quantitiy of other product' do
        let(:product) { Product.new(code: 'SR1', name: 'Strawberries', price: 500) }
        let(:quantity) { 2 }

        it 'does not apply discount if product code does not match' do
          expect { apply }.to raise_error(StandardError, /cannot be applied/)
          expect(basket_item.total_price).to eq(1000)
          expect(basket_item.discount).to eq(0)
          expect(basket_item.discounted_price).to eq(1000)
        end
      end
    end
  end
end
