# frozen_string_literal: true

require_relative '../../lib/errors/validation_error'

RSpec.describe ValidationError do
  describe '#initialize' do
    it 'stores provided errors array' do
      error = described_class.new(['Name missing', 'Price invalid'])
      expect(error.errors).to eq(['Name missing', 'Price invalid'])
    end

    it 'wraps a single error string into an array and formats message' do
      error = described_class.new('Name missing')
      expect(error.message).to eq('Validation failed: Name missing')
    end
  end
end
