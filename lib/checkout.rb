# frozen_string_literal: true

require_relative 'basket'

class Checkout
  attr_reader :basket, :pricing_rules, :subtotal, :discount, :total

  def initialize(pricing_rules = [])
    @basket = Basket.new
    @pricing_rules = pricing_rules
    @subtotal = 0
    @discount = 0
    @total = 0
    Event.new(:new_checkout_session, { checkout: to_s, pricing_rules: })
  end

  def scan(product)
    Event.new(:product_scanned, { code: product&.code, name: product&.name, price: product&.price_to_s })
    basket.add(product)

    true
  end

  def calculete_total
    basket.items.values.map { |basket_item| apply_rules(basket_item) }
    @subtotal = basket.items_total_price
    @total = basket.items_discounted_price
    @discount = (@subtotal - @total)

    Event.new(:checkout_calculated, { subtotal:, discount:, total: })

    print
  end

  def print
    puts "Subtotal: £#{subtotal / 100.0}"
    puts "Discount: £#{discount / 100.0}"
    puts "Total:    £#{total / 100.0}"
  end

  private

  def apply_rules(basket_item)
    basket_item.reset_discount

    rules = @pricing_rules.select { |r| r.applies_to?(basket_item) }
    rules.map { |rule| rule.apply(basket_item) } if rules.any?
  end
end
