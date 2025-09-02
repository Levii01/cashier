# frozen_string_literal: true

require_relative 'basket_item'

class Basket
  attr_reader :items

  def initialize
    @items = {}
  end

  def add(product)
    if @items.key?(product.code)
      @items[product.code].increment
    else
      @items[product.code] = BasketItem.new(product)
    end
  end

  def empty?
    @items.empty?
  end
end
