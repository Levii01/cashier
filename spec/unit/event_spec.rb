# frozen_string_literal: true

require 'fileutils'

RSpec.describe Event do
  subject(:event) { described_class.new(type, data) }

  let(:type) { :product_scanned }
  let(:data) { { code: 'GR1', price: 311 } }
  let(:log_file) { Event::LOG_FILE }

  before do
    described_class.clear_events!
    FileUtils.rm_f(log_file)
  end

  describe '#initialize' do
    it { expect(event.type).to eq(type) }
    it { expect(event.data).to eq(data) }
    it { expect(event.timestamp).to be_a(Time) }

    it 'adds the event to all_events' do
      expect { event }.to change { described_class.all_events.size }.by(1)
      expect(described_class.all_events.last).to eq(event)
    end

    it 'writes to the log file' do
      event
      content = File.read(log_file)
      expect(content).to include(event.type.to_s)
      expect(content).to include(event.data.inspect)
    end
  end

  describe '.all_events' do
    let(:event_a) { described_class.new(:a, {}) }
    let(:event_b) { described_class.new(:b, {}) }

    it 'returns all created events' do
      event_a
      event_b
      expect(described_class.all_events).to eq([event_a, event_b])
    end
  end

  describe '.clear_events!' do
    it 'clears the all_events array' do
      described_class.new(:a, {})
      expect(described_class.all_events).not_to be_empty
      described_class.clear_events!
      expect(described_class.all_events).to be_empty
    end
  end

  describe '#to_s' do
    subject(:event_to_s) { event.to_s }

    it 'returns formatted string' do
      expect(event_to_s).to include(type.to_s)
      expect(event_to_s).to include(data.inspect)
      expect(event_to_s).to match(/\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]/)
    end
  end

  describe '#to_h' do
    subject(:event_to_h) { event.to_h }

    it 'returns a hash with type, data and timestamp' do
      expect(event_to_h[:type]).to eq(type)
      expect(event_to_h[:data]).to eq(data)
      expect(event_to_h[:timestamp]).to be_a(Time)
    end
  end
end
