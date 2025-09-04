# frozen_string_literal: true

RSpec.describe Product do
  subject(:product) { described_class.new(code: 'CF1', price: 1123, name: 'Coffee') }

  it 'initializes with code, price, and name' do
    expect(product).to have_attributes(code: 'CF1', price: 1123, name: 'Coffee')
  end
end
