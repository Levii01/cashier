# frozen_string_literal: true

require 'yaml'

require_relative 'lib/checkout'
require_relative 'lib/product'
require_relative 'lib/basket'
require_relative 'lib/basket_item'
require_relative 'lib/pricing_rules/bulk_discount_rule'
require_relative 'lib/pricing_rules/bulk_percentage_rule'
require_relative 'lib/pricing_rules/buy_one_get_one_free_rule'

PRODUCTS_FILE = File.expand_path('./config/products.yml', __dir__)

PRODUCTS = YAML.load_file(PRODUCTS_FILE).to_h do |code, product|
  [code, Product.new(code:, price: product['price'], name: product['name'])]
end

PRICING_RULES = [].freeze
