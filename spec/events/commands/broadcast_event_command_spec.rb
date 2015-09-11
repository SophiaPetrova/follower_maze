require 'spec_helper'

describe :BroadcastEventCommand do
  let(:missing_sequence_number) { 'B' }
  let(:negative_sequence_number) { '-1|B' }
  let(:complete_command) { '1|B' }

  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(BroadcastEventCommand.parse(missing_sequence_number)).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(BroadcastEventCommand.parse(negative_sequence_number)).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = BroadcastEventCommand.parse(complete_command)

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to be_nil
        expect(command.to_user).to be_nil
      end
    end
  end
end
