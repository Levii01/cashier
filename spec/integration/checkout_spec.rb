# frozen_string_literal: true

RSpec.describe Checkout do
  subject(:calculete_total) { checkout.calculete_total }

  let(:checkout) { described_class.new(PRICING_RULES) }

  let(:gr1) { PRODUCTS['GR1'] }
  let(:sr1) { PRODUCTS['SR1'] }
  let(:cf1) { PRODUCTS['CF1'] }

  context 'when in a basket: GR1, SR1, GR1, GR1, CF1' do
    before { [gr1, sr1, gr1, gr1, cf1].each { |item| checkout.scan(item) } }

    it 'returns a total of £22.45' do
      calculete_total
      expect(checkout.subtotal).to eq(2556)
      expect(checkout.discount).to eq(311)
      expect(checkout.total).to eq(2245)
    end
  end

  context 'when in a basket: GR1, GR1' do
    before { [gr1, gr1].each { |item| checkout.scan(item) } }

    it 'returns a total of £3.11' do
      calculete_total
      expect(checkout.subtotal).to eq(622)
      expect(checkout.discount).to eq(311)
      expect(checkout.total).to eq(311)
    end
  end

  context 'when in a basket: SR1, SR1, GR1, SR1' do
    before { [sr1, sr1, gr1, sr1].each { |item| checkout.scan(item) } }

    it 'returns a total of £16.61' do
      calculete_total
      expect(checkout.subtotal).to eq(1811)
      expect(checkout.discount).to eq(150)
      expect(checkout.total).to eq(1661)
    end
  end

  context 'when in abasket: GR1, CF1, SR1, CF1, CF1' do
    before { [gr1, cf1, sr1, cf1, cf1].each { |item| checkout.scan(item) } }

    it 'returns a total of £30.57' do
      calculete_total
      expect(checkout.subtotal).to eq(4180)
      expect(checkout.discount).to eq(1123)
      expect(checkout.total).to eq(3057)
    end
  end

  context 'when in abasket: GR1, SR1, CF1' do
    before { [gr1, sr1, cf1].each { |item| checkout.scan(item) } }

    it 'returns the total price of the items £19.34' do
      calculete_total
      expect(checkout.subtotal).to eq(1934)
      expect(checkout.discount).to eq(0)
      expect(checkout.total).to eq(1934)
    end
  end
end
