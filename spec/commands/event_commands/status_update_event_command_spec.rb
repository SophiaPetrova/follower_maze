require 'spec_helper'

describe :StatusUpdateEventCommand do
  let(:missing_sequence_number) { 'S|54' }
  let(:negative_sequence_number) { '-1|S|54' }
  let(:complete_command) { '1|S|54' }

  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(StatusUpdateEventCommand.parse(missing_sequence_number)).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(StatusUpdateEventCommand.parse(negative_sequence_number)).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = StatusUpdateEventCommand.parse(complete_command)

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to eq(54)
        expect(command.to_user).to be_nil
      end
    end
  end
end
