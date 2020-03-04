require_relative '../lib/linter'
RSpec.describe Linter do

  let(:files) { %w(spec/test.css spec/test.yml) }
  let(:css_sample_1) { "* { \n  margin: 0;\n  padding: 0;\n}" }
  let(:write_css_file) { File.open(files[0], 'w') { |f| f.puts css_sample_1 } }
  let(:yaml_start) {"---\nChecks:\n" }
  let(:rule_space_before_brace) { "- spaces_before_first_brace:\n  - Enabled: true\n" }
  let(:rule_space_after_brace) { "- spaces_after_first_brace:\n  - Enabled: false\n" }
  let(:write_yaml_file) { File.open(files[1], 'w') do |f|
     f.puts yaml_start, rule_space_before_brace, rule_space_after_brace
  end }
  let(:delete_files) { files.each {|file| File.delete(file) if File.exist?(file) } }

  describe '#fill_checks' do
    it 'Opens a yaml file, return an array with the rules that will check.' do
      write_css_file
      write_yaml_file
      linter = Linter.new(files[0])
      arr = %w(check_spaces_before_first_brace)
      expect(linter.fill_checks(files[1])).to eql(arr)
      delete_files
    end
  end

  describe '#do_checks' do

    before do
      rule_space_before_brace.gsub! 'true', 'false'
      rule_space_after_brace.gsub! 'false', 'true'
    end

    after do
      rule_space_before_brace.gsub! 'false', 'true'
      rule_space_after_brace.gsub! 'true', 'false'
    end

    it 'Returns an array with the methods that execute.' do
      write_css_file
      write_yaml_file
      linter = Linter.new(files[0])
      arr = %w(check_spaces_after_first_brace)
      linter.fill_checks(files[1])
      expect(linter.do_checks).to eql(arr)
      files.each { |file| File.delete(file) if File.exist?(file) }
    end

    context 'When it founds a false rule'
    let(:false_rule) { "- false_rule:\n  - Enabled: true\n" }
    let(:write_yaml_file_1) { File.open(files[2], 'w') do |f|
      f.puts yaml_start, false_rule
    end }
    it 'Raise an error if there isn\'t a rule for it' do
      write_css_file
      files << 'spec/test1.yml'
      write_yaml_file_1
      linter = Linter.new(files[0])
      linter.fill_checks(files[2])
      expect {linter.do_checks}.to raise_error(NoMethodError)
    end
  end
end
