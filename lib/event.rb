# frozen_string_literal: true

require 'fileutils'

class Event
  LOG_TO_FILE = true
  LOG_TO_CONSOLE = true

  @all_events = []

  class << self
    attr_reader :all_events

    def clear_events!
      @all_events.clear
      File.write('cashier.log', '') if File.exist?(LOG_FILE)
    end
  end

  attr_reader :type, :data, :timestamp

  LOG_FILE = 'log/cashier.log'

  def initialize(type, data = {})
    @type = type.to_sym
    @data = data.freeze
    @timestamp = Time.now

    append_logs
  end

  def to_s
    "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{type}: #{data.inspect}"
  end

  def to_h
    { type:, data:, timestamp: }
  end

  def append_logs
    self.class.all_events << self
    append_to_file if LOG_TO_FILE
    puts self if LOG_TO_CONSOLE
  end

  private

  def append_to_file
    dir = File.dirname(LOG_FILE)
    FileUtils.mkdir_p(dir)

    File.open(LOG_FILE, 'a') { |f| f.puts(to_s) }
  end
end
