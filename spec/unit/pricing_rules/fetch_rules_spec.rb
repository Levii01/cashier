# frozen_string_literal: true

RSpec.describe PricingRules::FetchRules do
  describe '.call' do
    subject(:call) { described_class.call }

    it 'returns an array of promotion rules' do
      expect(call.map(&:class)).to include(
        PricingRules::BuyOneGetOneFreeRule,
        PricingRules::BulkDiscountRule,
        PricingRules::BulkPercentageRule
      )
    end

    it 'raises error on unknown promotion type' do
      allow(YAML).to receive(:safe_load_file).and_return(
        promotions: [{ type: 'invalid_rule' }]
      )

      expect { described_class.call }.to raise_error(ArgumentError, /Unknown promotion type/)
    end
  end
end
