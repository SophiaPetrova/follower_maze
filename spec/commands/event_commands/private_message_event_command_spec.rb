require 'spec_helper'

describe :PrivateMessageEventCommand do
  let(:missing_sequence_number) { 'P|2|56' }
  let(:negative_sequence_number) { '-1|P|2|56' }
  let(:complete_command) { '1|P|2|3' }

  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(PrivateMessageEventCommand.parse(missing_sequence_number)).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(PrivateMessageEventCommand.parse(negative_sequence_number)).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = PrivateMessageEventCommand.parse(complete_command)

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to eq(2)
        expect(command.to_user).to eq(3)
      end
    end
  end

  context :command do
    it 'returns the string representation of the event command' do
        command = PrivateMessageEventCommand.parse(complete_command)
        expect(command.command).to eq(complete_command)
    end
  end
end
