# rubocop: disable Metrics/PerceivedComplexity
# rubocop: disable Metrics/CyclomaticComplexity

require 'yaml'
require 'ripper'
require_relative 'write_messages'
require_relative 'error'

#
#  Naming of variables:
#    ln => line number
#    g => group
#    ec => error count
#    aob => after opening brace
#

class Linter
  include Error

  def initialize(css_file)
    @checks = []
    @error_message = WriteMessage.new
    (raise ArgumentError, ERROR_NO_FILE if css_file.nil?)
    @css_file = File.open(css_file, 'r')
    @css_read = @css_file.read
    @css_file.close
    @ec = 0
  end

  def fill_checks(rules_file)
    YAML.load_file(rules_file)['Checks'].each do |k, _v|
      k.each { |key, value| @checks.push("check_#{key.to_sym}") if value[0]['Enabled'] }
    end
    @checks
  end

  def do_checks
    @checks.each { |method| @ec += send(method) }
  end

  def write_errors
    puts "Number of errors: #{@ec}\n\n"
    @error_message.write_messages
  end

  def check_spaces_before_first_brace
    ln = 0
    g = 'spaces_before_first_brace'
    ec = 0
    @css_read.each_line do |line|
      ln += 1
      next unless /{/.match(line)

      unless /\s{/.match(line)
        @error_message.save_message(g, "#{ERROR_MISSING_SPACE} #{ln}\n", ERROR)
        ec += 1
      end
    end
    ec
  end

  def check_spaces_after_first_brace
    ln = 0
    g = 'spaces_after_first_brace'
    ec = 0
    @css_read.each_line do |line|
      ln += 1
      next unless /{/.match(line)

      if /{[\s]+\n/.match(line)
        @error_message.save_message(g, "#{ERROR_EXTRA_SPACE} #{ln}\n", ERROR)
        ec += 1
      end
    end
    ec
  end

  def check_rules_indentation
    ln = 0
    g = 'rules_indentation'
    ec = 0
    aob = false
    save_message = lambda do |s|
      @error_message.save_message(g, "#{ERROR_MISSING_INDENTATION.gsub('spaces', s)} #{ln}\n", ERROR)
    end
    @css_read.each_line do |line|
      ln += 1
      aob = true if /{/.match(line)
      next if /{/.match(line)

      aob = false if /}/.match(line)
      next if /}/.match(line)

      words = Ripper.tokenize(line) if aob
      ec += 1 if aob && (words[0] != "\s\s" || words[0] == "\s")
      save_message.call('1 space') if aob && words[0] == "\s" && words[0] != "\s\s"
      save_message.call('2 spaces') if aob && words[0] != "\s\s" && words[0] != "\s"
    end
    ec
  end

  def check_space_after_colon
    ln = 0
    g = 'space_after_colon'
    ec = 0
    aob = false
    save_message = lambda do
      @error_message.save_message(g, "#{ERROR_MISSING_SPACE_AFTER_COLON} #{ln}\n", ERROR)
    end
    @css_read.each_line do |line|
      ln += 1
      aob = true if /{/.match(line)
      next if /{/.match(line)

      aob = false if /}/.match(line)
      next if /}/.match(line)

      ec += 1 if aob && /:[^\s]/.match(line)
      save_message.call if aob && /:[^\s]/.match(line)
    end
    ec
  end

  def check_no_uppcase_selectors
    ln = 0
    g = 'no_uppcase_selectors'
    ec = 0
    @css_read.each_line do |line|
      ln += 1
      next unless /{/.match(line)

      if /[A-Z]/.match(line)
        @error_message.save_message(g, "#{WARNING_NO_UPPCASE_SELECTORS} #{ln}\n", WARNING)
        ec += 1
      end
    end
    ec
  end
end

# rubocop: enable Metrics/PerceivedComplexity
# rubocop: enable Metrics/CyclomaticComplexity
