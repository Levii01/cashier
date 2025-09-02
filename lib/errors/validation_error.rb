# frozen_string_literal: true

# Raised when one or more validation errors occur during input checks.
class ValidationError < StandardError
  attr_reader :errors

  def initialize(errors)
    @errors = Array(errors)
    super("Validation failed: #{@errors.join(', ')}")
  end
end
