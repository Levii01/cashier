# frozen_string_literal: true

module PricingRules
  class BulkPercentageRule
    attr_reader :product_code

    def initialize(product_code:, threshold:, percentage:)
      @product_code = product_code
      @threshold = threshold
      @percentage = percentage
    end

    def applies_to?(basket_item)
      basket_item.product.code == @product_code && basket_item.quantity >= @threshold
    end

    def apply(basket_item)
      raise StandardError, "The discount cannot be applied: #{basket_item.inspect}" unless applies_to?(basket_item)

      discount_per_item = basket_item.product.price * @percentage
      discount = discount_per_item * basket_item.quantity

      basket_item.set_discount(discount.ceil, self)
    end
  end
end
