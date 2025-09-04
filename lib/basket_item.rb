# frozen_string_literal: true

class BasketItem
  attr_reader :product, :quantity, :discount

  def initialize(product:, quantity: 1)
    @product = product
    @quantity = quantity
    @discount = 0
    @pricing_rule = nil

    validate!
  end

  def total_price
    @product.price * @quantity
  end

  def discounted_price
    (@product.price * @quantity) - @discount
  end

  def increment
    @quantity += 1
  end

  def set_discount(new_discount, new_pricing_rule)
    return unless new_discount > @discount

    @discount = new_discount
    @pricing_rule = new_pricing_rule
  end

  def reset_discount
    @discount = 0
    @pricing_rule = nil
  end

  # def decrement
  #   raise StandardError, "Cannot decrement when quantity #{@quantity}" if @quantity < 1

  #   @quantity -= 1
  # end

  private

  def validate!
    errors = []
    errors << 'Product must be provided' if product.nil?
    errors << 'Quantity must be a positive integer' if quantity.nil? || !quantity.is_a?(Integer) || quantity < 1
    raise ValidationError, errors unless errors.empty?
  end
end
