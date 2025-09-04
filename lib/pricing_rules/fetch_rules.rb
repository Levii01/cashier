# frozen_string_literal: true

require 'yaml'
require_relative 'buy_one_get_one_free_rule'
require_relative 'bulk_discount_rule'
require_relative 'bulk_percentage_rule'

module PricingRules
  class FetchRules
    CONFIG_PATH = File.join(__dir__, '../../config/promotions.yml')
    RULES = {
      buy_one_get_one_free: { klass: BuyOneGetOneFreeRule, keys: [:product_code] },
      bulk_discount: { klass: BulkDiscountRule, keys: %i[product_code threshold new_price] },
      bulk_percentage: { klass: BulkPercentageRule, keys: %i[product_code threshold percentage] }
    }.freeze

    def self.call
      load_promotions.map do |promo|
        rule_config = RULES[promo[:type].to_sym]
        raise ArgumentError, "Unknown promotion type: #{promo[:type]}" unless rule_config

        kw_args = promo.slice(*rule_config[:keys])
        rule_config[:klass].new(**kw_args)
      end
    end

    def self.load_promotions
      YAML.safe_load_file(CONFIG_PATH, symbolize_names: true)[:promotions]
    end
    private_class_method :load_promotions
  end
end
