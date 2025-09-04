# frozen_string_literal: true

require_relative 'base'
require 'pry'

co = Checkout.new(PRICING_RULES)

co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
co.scan(PRODUCTS['GR1'])
