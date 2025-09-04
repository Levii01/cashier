# frozen_string_literal: true

require_relative 'basket_item'
require_relative 'errors/validation_error'

class Basket
  attr_reader :items

  def initialize
    @items = {}
  end

  def add(product)
    raise ValidationError, 'Product must be provided' unless product.is_a?(Product)

    if @items.key?(product.code)
      @items[product.code].increment
    else
      @items[product.code] = BasketItem.new(product:)
    end
  end

  def items_total_price
    items.values.sum(&:total_price)
  end

  def items_discounted_price
    items.values.sum(&:discounted_price)
  end

  def empty?
    @items.empty?
  end
end
