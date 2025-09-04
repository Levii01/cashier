# frozen_string_literal: true

# Represents a purchasable item with a name and unit price.
class Product
  attr_reader :code, :price, :name

  def initialize(code:, price:, name:)
    @code = code
    @price = price
    @name = name
  end

  def price_to_s
    "£#{price / 100.0}"
  end
end
