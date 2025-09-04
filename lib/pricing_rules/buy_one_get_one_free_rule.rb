# frozen_string_literal: true

module PricingRules
  class BuyOneGetOneFreeRule
    attr_reader :product_code

    def initialize(product_code:)
      @product_code = product_code
    end

    def applies_to?(basket_item)
      basket_item.product.code == @product_code && basket_item.quantity >= 2
    end

    def apply(basket_item)
      raise StandardError, "The discount cannot be applied: #{basket_item.inspect}" unless applies_to?(basket_item)

      free_items = basket_item.quantity / 2
      discount = free_items * basket_item.product.price

      basket_item.set_discount(discount, self)
    end
  end
end
