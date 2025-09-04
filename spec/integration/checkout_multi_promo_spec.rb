# frozen_string_literal: true

RSpec.describe Checkout, type: :integration do
  let(:coffee) { Product.new(code: 'CF1', name: 'Coffee', price: 1123) }
  let(:bogo) { PricingRules::BuyOneGetOneFreeRule.new(product_code: 'CF1') }
  let(:bulk) { PricingRules::BulkPercentageRule.new(product_code: 'CF1', threshold: 3, percentage: 1.0 / 3) }

  let(:checkout) { described_class.new([bogo, bulk]) }

  describe 'applying multiple rules to the same product' do
    subject(:calculete_total) { checkout.calculete_total }

    context 'when 2 coffees in basket' do
      before { 2.times { checkout.scan(coffee) } }

      it 'applies BOGO and chooses the correct discounted price' do
        calculete_total
        expect(checkout.subtotal).to eq(2246)
        expect(checkout.total).to eq(1123)
        expect(checkout.discount).to eq(1123)
      end
    end

    context 'when 3 coffees in basket' do
      before { 3.times { checkout.scan(coffee) } }

      it 'applies the best discount among BOGO and bulk percentage' do
        calculete_total
        expect(checkout.subtotal).to eq(3369)
        expect(checkout.total).to eq(2246)
        expect(checkout.discount).to eq(1123)
      end
    end

    context 'when 4 coffees in basket' do
      before { 4.times { checkout.scan(coffee) } }

      it 'applies the promotion that gives the lowest total price' do
        calculete_total
        expect(checkout.subtotal).to eq(4492)
        expect(checkout.total).to eq(2246)
        expect(checkout.discount).to eq(2246)
      end
    end
  end
end
