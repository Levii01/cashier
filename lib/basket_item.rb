# frozen_string_literal: true

class BasketItem
  attr_reader :product, :quantity

  def initialize(product:, quantity: 1)
    @product = product
    @quantity = quantity
  end

  def total_price
    @product.price * @quantity
  end

  def increment
    @quantity += 1
  end

  def decrement
    @quantity -= 1
  end
end
