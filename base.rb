# frozen_string_literal: true

require 'yaml'

require_relative 'config/enviroment'
require_relative 'lib/checkout'
require_relative 'lib/product'
require_relative 'lib/basket'
require_relative 'lib/basket_item'
require_relative 'lib/event'
require_relative 'lib/pricing_rules/fetch_rules'
require_relative 'lib/errors/validation_error'

PRODUCTS_FILE = File.expand_path('./config/products.yml', __dir__)

PRODUCTS = YAML.load_file(PRODUCTS_FILE).to_h do |code, product|
  [code, Product.new(code:, price: product['price'], name: product['name'])]
end
PRICING_RULES = PricingRules::FetchRules.call
