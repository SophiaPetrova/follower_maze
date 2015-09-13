require 'spec_helper'

describe :UnfollowEventCommand do
  let(:missing_sequence_number) { 'U|12|9' }
  let(:negative_sequence_number) { '-1|U|12|9' }
  let(:complete_command) { '1|U|12|9' }

  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(UnfollowEventCommand.parse(missing_sequence_number)).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(UnfollowEventCommand.parse(negative_sequence_number)).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = UnfollowEventCommand.parse(complete_command)

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to eq(12)
        expect(command.to_user).to eq(9)
      end
    end
  end

  context :command do
    it 'returns the string representation of the event command' do
      command = UnfollowEventCommand.parse(complete_command)
      expect(command.command).to eq(complete_command)
    end
  end
end
