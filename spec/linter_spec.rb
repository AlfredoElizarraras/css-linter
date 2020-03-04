require_relative '../lib/linter'
RSpec.describe Linter do
  describe '#fill_checks' do
    it 'opens a yaml file, return an array with the rules that will check.' do
      file = 'spec/test.yml'
      File.open(file, 'w') do |f|
        text = "---\nChecks:\n- spaces_before_first_brace:\n  - Enabled: true\n"
        text += "- spaces_after_first_brace:\n  - Enabled: false"
        f.puts text
      end
      linter = Linter.new(file)
      arr = %w(check_spaces_before_first_brace check_spaces_after_first_brace)
      expect(linter.fill_checks).to eql(arr)
      File.delete(file) if File.exist?(file)
    end
  end
end
