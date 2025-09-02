# frozen_string_literal: true

# require_relative '../base'
RSpec.describe Checkout do
  let(:checkout) { described_class.new }

  let(:gr1) { PRODUCTS['GR1'] }
  let(:sr1) { PRODUCTS['SR1'] }
  let(:cf1) { PRODUCTS['CF1'] }

  context 'when in a basket: GR1, SR1, GR1, GR1, CF1' do
    it 'returns a total of £22.45' do
      [gr1, sr1, gr1, gr1, cf1].each { |item| checkout.scan(item) }
      expect(checkout.total).to eq(22.45)
    end
  end

  context 'when in a basket: GR1, GR1' do
    it 'returns a total of £3.11' do
      [gr1, gr1].each { |item| checkout.scan(item) }
      expect(checkout.total).to eq(3.11)
    end
  end

  context 'when in a basket: SR1, SR1, GR1, SR1' do
    it 'returns a total of £16.61' do
      [sr1, sr1, gr1, sr1].each { |item| checkout.scan(item) }
      expect(checkout.total).to eq(16.61)
    end
  end

  context 'when in abasket: GR1, CF1, SR1, CF1, CF1' do
    it 'returns a total of £30.57' do
      [gr1, cf1, sr1, cf1, cf1].each { |item| checkout.scan(item) }
      expect(checkout.total).to eq(30.57)
    end
  end

  it 'returns the total price of the items' do
    checkout.scan('GR1')
    checkout.scan('SR1')
    checkout.scan('CF1')
    expect(checkout.total).to eq(1944)
  end
end
