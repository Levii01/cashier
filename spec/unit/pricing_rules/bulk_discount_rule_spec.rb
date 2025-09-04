# frozen_string_literal: true

RSpec.describe PricingRules::BulkDiscountRule do
  let(:product) { Product.new(code: 'SR1', name: 'Strawberries', price: 500) }
  let(:rule)    { described_class.new(product_code: 'SR1', threshold: 3, new_price: 450) }
  let(:quantity) { 3 }

  describe '#applies_to?' do
    subject(:applies_to?) { rule.applies_to?(basket_item) }

    let(:basket_item) { BasketItem.new(product:, quantity:) }

    context 'with 3 quantities of product' do
      it 'returns true when product code matches and quantity >= threshold' do
        expect(applies_to?).to be true
      end
    end

    context 'with 2 quantities of product' do
      let(:quantity) { 2 }

      it 'returns false when product code matches but quantity < threshold' do
        expect(applies_to?).to be false
      end
    end

    context 'with 3 quantities of other product' do
      let(:product) { Product.new(code: 'GR1', name: 'Green Tea', price: 311) }

      it 'returns false when product code does not match' do
        expect(applies_to?).to be false
      end
    end
  end

  describe '#apply' do
    subject(:apply) { rule.apply(basket_item) }

    let(:basket_item) { BasketItem.new(product:, quantity:) }
    let(:quantity) { 3 }

    context 'when basket item qualifies for bulk discount' do
      context 'with 3 quantities of product' do
        let(:quantity) { 3 }

        it 'applies discount correctly using new price for all items' do
          apply

          expect(basket_item.total_price).to eq(1500)
          expect(basket_item.discount).to eq(150)
          expect(basket_item.discounted_price).to eq(1350)
        end
      end

      context 'with 5 quantities of product' do
        let(:quantity) { 5 }

        it 'applies discount correctly for all items' do
          apply

          expect(basket_item.total_price).to eq(2500)
          expect(basket_item.discount).to eq(250)
          expect(basket_item.discounted_price).to eq(2250)
        end
      end
    end

    context 'when basket item does not qualify' do
      context 'with 2 quantities of product' do
        let(:quantity) { 2 }

        it 'does not apply discount if quantity < threshold' do
          expect { apply }.to raise_error(StandardError, /cannot be applied/)
          expect(basket_item.total_price).to eq(1000)
          expect(basket_item.discount).to eq(0)
          expect(basket_item.discounted_price).to eq(1000)
        end
      end

      context 'with 3 quantities of other product' do
        let(:product) { Product.new(code: 'GR1', name: 'Green Tea', price: 311) }
        let(:quantity) { 3 }

        it 'does not apply discount if product code does not match' do
          expect { apply }.to raise_error(StandardError, /cannot be applied/)
          expect(basket_item.total_price).to eq(933)
          expect(basket_item.discount).to eq(0)
          expect(basket_item.discounted_price).to eq(933)
        end
      end
    end
  end
end
