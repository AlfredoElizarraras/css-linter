require_relative '../lib/linter'

RSpec.describe Linter do
  let(:files) { %w[spec/test.css spec/test.yml] }
  let(:css_sample) { "* {\n  margin: 0;\n  padding: 0;\n}" }
  let(:write_css_file) { File.open(files[0], 'w') { |f| f.puts css_sample } }
  let(:yaml_start) { "---\nChecks:\n" }
  let(:rule_space_before_brace) { "- spaces_before_first_brace:\n  - Enabled: true\n" }
  let(:rule_space_after_brace) { "- spaces_after_first_brace:\n  - Enabled: false\n" }
  let(:write_yaml_file) do
    File.open(files[1], 'w') do |f|
      f.puts yaml_start, rule_space_before_brace, rule_space_after_brace
    end
  end
  let(:delete_files) { files.each { |file| File.delete(file) if File.exist?(file) } }
  let(:spaces_before_first_brace_error) { /There's a missing space in line: / }
  let(:spaces_after_first_brace_error) { /There's an extra space in line: / }

  describe '#fill_checks' do
    it 'Opens a yaml file, return an array with the rules that will check.' do
      write_css_file
      write_yaml_file
      linter = Linter.new(files[0])
      arr = %w[check_spaces_before_first_brace]
      expect(linter.fill_checks(files[1])).to eql(arr)
      delete_files
    end
  end

  describe '#do_checks' do
    context 'When it found valid rules' do
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
        arr = %w[check_spaces_after_first_brace]
        linter.fill_checks(files[1])
        expect(linter.do_checks).to eql(arr)
        delete_files
      end
    end

    context 'When it founds a false rule' do
      let(:false_rule) { "- false_rule:\n  - Enabled: true\n" }
      let(:write_yaml_file_1) do
        File.open(files[2], 'w') do |f|
          f.puts yaml_start, false_rule
        end
      end
      it 'Raise an error if there isn\'t a rule that match in the yaml file.' do
        write_css_file
        files << 'spec/test1.yml'
        write_yaml_file_1
        linter = Linter.new(files[0])
        linter.fill_checks(files[2])
        expect { linter.do_checks }.to raise_error(NoMethodError)
        delete_files
        files.delete_at(2)
      end
    end
  end

  describe '#write_errors' do
    context 'When errors are founded and saved.' do
      before do
        css_sample.gsub! '* {', '*{'
      end

      after do
        css_sample.gsub! '*{', '* {'
      end

      it 'Write messages in console.' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        linter.check_spaces_before_first_brace
        expect do
          linter.write_errors
        end.to output(spaces_before_first_brace_error).to_stdout
        delete_files
      end
    end

    context 'When errors aren\'t founded' do
      it 'Write Number of errors: 0.' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        linter.check_spaces_after_first_brace
        expect do
          linter.write_errors
        end.to output("Number of errors: 0\n").to_stdout
        delete_files
      end
    end
  end

  describe '#check_spaces_before_first_brace' do
    context 'When found an error.' do
      before do
        css_sample.gsub! '* {', '*{'
      end

      after do
        css_sample.gsub! '*{', '* {'
      end

      it 'Return the count of the times it found that ther\'s missing a space before opening brace.' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        expect(linter.check_spaces_before_first_brace).to eql(1)
        delete_files
      end

      it 'Saves the message that there is a missing space (it is show when call write_errors).' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        linter.check_spaces_before_first_brace
        expect do
          linter.write_errors
        end.to output(spaces_before_first_brace_error).to_stdout
        delete_files
      end
    end
  end

  describe '#check_spaces_after_first_brace' do
    context 'When found an error.' do
      before do
        css_sample.gsub! '* {', '* { '
      end

      after do
        css_sample.gsub! '* { ', '* {'
      end

      it 'Return the count of the times it found the a space after a opening brace.' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        expect(linter.check_spaces_after_first_brace).to eql(1)
        delete_files
      end

      it 'Saves the message that there is an extra space (it is show when call write_errors).' do
        write_css_file
        write_yaml_file
        linter = Linter.new(files[0])
        linter.check_spaces_after_first_brace
        expect do
          linter.write_errors
        end.to output(spaces_after_first_brace_error).to_stdout
        delete_files
      end
    end
  end
end