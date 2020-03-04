# rubocop: disable Metrics/PerceivedComplexity:
# rubocop: disable Metrics/CyclomaticComplexity
require 'colorize'

class WriteMessage
  def initialize
    @messages = {}
  end

  def write_messages
    @messages.each do |key, value|
      puts "Messages from #{key}:"
      value.each_line { |message| puts message }
    end
  end

  def save_message(check, message, level)
    if level.zero? && @messages[check].nil?
      @messages[check] = "\t- #{message.red}"
    elsif level.zero? && !@messages[check].nil?
      @messages[check] << "\t- #{message.red}"
    elsif level == 1 && @messages[check].nil?
      @messages[check] = "\t- #{message.yellow}"
    elsif level == 1 && !@messages[check].length.nil?
      @messages[check] << "\t- #{message.yellow}"
    end
  end
end

# rubocop: enable Metrics/PerceivedComplexity:
# rubocop: enable Metrics/CyclomaticComplexity
