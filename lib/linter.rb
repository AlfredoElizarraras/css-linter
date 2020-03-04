require 'yaml'
require_relative 'write_messages'
require_relative 'error'

class Linter
  include Error
  attr_accessor :css_read, :errors, :checks

  def initialize(css_file)
    @checks = []
    @error_message = WriteMessage.new
    (raise ArgumentError, ERROR_NO_FILE if css_file.nil?)
    @css_file = File.open(css_file, 'r')
    @css_read = @css_file.read
    @css_file.close
  end

  def fill_checks
    YAML.load_file('checks.yml')['Checks'].each do |k, _v|
      k.each { |key, value| checks.push("check_#{key.to_sym}") if value[0]['Enabled'] }
    end
  end

  def do_checks
    checks.each { |method| send(method) }
  end

  def write_errors
    @error_message.write_messages
  end

  def check_spaces_before_first_brace
    line_number = 0
    group = 'spaces_before_first_brace'
    css_read.each_line do |line|
      line_number += 1
      next unless /{/.match(line)

      unless /\s{/.match(line)
        @error_message.save_message(group, "#{ERROR_MISSING_SPACE} #{line_number}\n", ERROR)
      end
    end
  end

  def check_spaces_after_first_brace
    line_number = 0
    group = 'spaces_after_first_brace'
    css_read.each_line do |line|
      line_number += 1
      next unless /{/.match(line)

      unless /{[\s]+\n/.match(line)
        @error_message.save_message(group, "#{ERROR_EXTRA_SPACE} #{line_number}\n", ERROR)
      end
    end
  end
end
