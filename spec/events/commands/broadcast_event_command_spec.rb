require 'spec_helper'

describe :BroadcastEventCommand do
  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(BroadcastEventCommand.parse('54|B|1')).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(BroadcastEventCommand.parse('-1|B')).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = BroadcastEventCommand.parse('1|B')

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to be_nil
        expect(command.to_user).to be_nil
      end
    end
  end
end
