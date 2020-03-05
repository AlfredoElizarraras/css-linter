require 'yaml'
require 'ripper'
require_relative 'write_messages'
require_relative 'error'

class Linter
  include Error

  def initialize(css_file)
    @checks = []
    @error_message = WriteMessage.new
    (raise ArgumentError, ERROR_NO_FILE if css_file.nil?)
    @css_file = File.open(css_file, 'r')
    @css_read = @css_file.read
    @css_file.close
    @errors_count = 0
  end

  def fill_checks(rules_file)
    YAML.load_file(rules_file)['Checks'].each do |k, _v|
      k.each { |key, value| @checks.push("check_#{key.to_sym}") if value[0]['Enabled'] }
    end
    @checks
  end

  def do_checks
    @checks.each { |method| @errors_count += send(method) }
  end

  def write_errors
    puts "Number of errors: #{@errors_count}\n"
    @error_message.write_messages
  end

  def check_spaces_before_first_brace
    line_number = 0
    group = 'spaces_before_first_brace'
    errors_count = 0
    @css_read.each_line do |line|
      line_number += 1
      next unless /{/.match(line)

      unless /\s{/.match(line)
        @error_message.save_message(group, "#{ERROR_MISSING_SPACE} #{line_number}\n", ERROR)
        errors_count += 1
      end
    end
    errors_count
  end

  def check_spaces_after_first_brace
    line_number = 0
    group = 'spaces_after_first_brace'
    errors_count = 0
    @css_read.each_line do |line|
      line_number += 1
      next unless /{/.match(line)

      if /{[\s]+\n/.match(line)
        @error_message.save_message(group, "#{ERROR_EXTRA_SPACE} #{line_number}\n", ERROR)
        errors_count += 1
      end
    end
    errors_count
  end

  def check_rules_indentation
    ln = 0
    g = 'rules_indentation'
    errors_count = 0
    after_opening_brace = false
    @css_read.each_line do |line|
      ln += 1
      after_opening_brace = true if /{/.match(line)
      next if /{/.match(line)

      after_opening_brace = false if /}/.match(line)
      next if /}/.match(line)

      words = Ripper.tokenize(line) if after_opening_brace
      @error_message.save_message(g, "#{ERROR_MISSING_INDENTATION.gsub('spaces', '2 spaces')} #{ln}\n", ERROR) if after_opening_brace && words[0] != "\s\s"
      # @error_message.save_message(g, "#{ERROR_MISSING_INDENTATION.gsub('spaces', '1 spaces')} #{ln}\n", ERROR) if after_opening_brace && words[0] == "\s"
      errors_count += 1 if after_opening_brace && (words[0] != "\s\s" || words[0] == "\s")
    end
    errors_count
  end
end
