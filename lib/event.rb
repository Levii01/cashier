# frozen_string_literal: true

require 'fileutils'

class Event
  LOG_TO_FILE = true
  LOG_TO_CONSOLE = ENV['ENVIROMENT'] != 'test' && true
  LOG_FILE = "log/#{ENV.fetch('ENVIROMENT', 'development')}_#{Time.now.to_date}.log".freeze

  @all_events = []

  class << self
    attr_reader :all_events

    def clear_events!
      @all_events.clear
    end
  end

  attr_reader :type, :data, :timestamp

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
    register_event
    write_to_file if LOG_TO_FILE
    print_to_console if LOG_TO_CONSOLE
  end

  private

  def register_event
    self.class.all_events << self
  end

  def write_to_file
    FileUtils.mkdir_p(File.dirname(LOG_FILE))
    File.open(LOG_FILE, 'a') { |f| f.puts(to_s) }
  end

  def print_to_console
    puts self
  end
end
