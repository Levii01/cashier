# frozen_string_literal: true

require_relative 'basket'

class Checkout
  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
    @basket = Basket.new
  end

  def scan(item)
    @basket.add(item)
  end

  def total
    @basket.sum(&:price)
  end
end
