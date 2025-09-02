# frozen_string_literal: true

# Represents a item in the basket with a product and its quantity.
class BasketItem
  attr_reader :product, :quantity

  def initialize(product:, quantity: 1)
    @product = product
    @quantity = quantity

    validation
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

  private

  def validation
    errors = []
    errors << 'Product must be provided' if product.nil?
    errors << 'Quantity must be a positive integer' if quantity.nil? || !quantity.is_a?(Integer) || quantity < 1
    raise ValidationError, errors unless errors.empty?
  end
end
