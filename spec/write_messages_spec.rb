require_relative '../lib/write_messages'

RSpec.describe WriteMessage do
  let(:error_group) { 'Error group' }
  let(:error_message) { 'There\'s a missing line at line:' }
  let(:message_error_level) { 0 }
  let(:error_match) { /\e\[0;31;49m.+\e\[0m$/ }
  let(:warning_group) { 'Warning group' }
  let(:warning_message) { 'There\'s no use of bem convention at line: ' }
  let(:message_warning_level) { 1 }
  let(:warning_match) { /\e\[0;33;49m.+\e\[0m$/ }

  describe '#save_message' do
    context 'When it specify that it is an error.' do
      it 'Return the message(s) with red color in the specified group.' do
        message = WriteMessage.new
        expect(message.save_message(error_group, error_message, message_error_level)).to match(error_match)
      end
    end

    context 'When it specify that it is a warning.' do
      it 'Return the message(s) with yellow color in the specified group.' do
        message = WriteMessage.new
        expect(message.save_message(warning_group, warning_message, message_warning_level)).to match(warning_match)
      end
    end
  end

  describe '#write_messages' do
    context 'When there are errors to show.' do
      it 'Display the errors or warning on the console.' do
        message = WriteMessage.new
        message.save_message(warning_group, warning_message, message_warning_level)
        expect do
          message.write_messages
        end.to output(/Warning group:\n.+There\'s no use of bem convention at line:/).to_stdout
      end
    end
  end
end
