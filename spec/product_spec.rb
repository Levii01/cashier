# frozen_string_literal: true

require_relative '../lib/product'

RSpec.describe Product do
  subject(:product) { described_class.new(code: 'CF1', price: 11.23, name: 'Coffee') }

  it 'initializes with code, price, and name' do
    expect(product).to have_attributes(code: 'CF1', price: 11.23, name: 'Coffee')
  end
end
