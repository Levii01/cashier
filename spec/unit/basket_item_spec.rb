# frozen_string_literal: true

RSpec.describe BasketItem do
  let(:basket_item) { described_class.new(product:, quantity:) }
  let(:product) { Product.new(code: 'GR1', price: 311, name: 'Green Tea') }
  let(:quantity) { 5 }

  describe '#initialize' do
    context 'when quantity not defined' do
      let(:basket_item) { described_class.new(product:) }

      it 'creates a BasketItem with default quantity 1' do
        expect(basket_item).to have_attributes(product:, quantity: 1)
      end
    end

    context 'when quantity more than 1' do
      it 'creates a BasketItem with default quantity 1' do
        expect(basket_item).to have_attributes(product:, quantity: 5)
      end
    end
  end

  describe 'validations' do
    context 'when product not provided' do
      let(:product) { nil }

      it 'raises an error if product is nil' do
        expect { basket_item }.to raise_error(ValidationError, 'Validation failed: Product must be provided')
      end
    end

    context 'when quantity is nil' do
      let(:quantity) { nil }

      it 'raises an error if product is nil' do
        expect { basket_item }.to raise_error(ValidationError,
                                              'Validation failed: Quantity must be a positive integer')
      end
    end
  end

  describe '#increment' do
    subject(:increment) { basket_item.increment }

    it 'increases the quantity by 1' do
      expect { increment }.to change(basket_item, :quantity).from(5).to(6)
    end
  end

  # describe '#decrement' do
  #   subject(:decrement) { basket_item.decrement }

  #   it 'decreases the quantity by 1' do
  #     expect { decrement }.to change(basket_item, :quantity).from(5).to(4)
  #   end
  # end

  describe '#total_price' do
    subject(:total_price) { basket_item.total_price }

    it 'calculates total price correctly' do
      expect(total_price).to eq(1555)
    end
  end
end
