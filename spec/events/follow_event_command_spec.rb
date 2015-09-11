require 'spec_helper'

describe :FollowCommand do
  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(FollowEventCommand.parse('1|U|12|9')).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(FollowEventCommand.parse('-1|F|12|9')).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = FollowEventCommand.parse('1|F|12|9')

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to eq(12)
        expect(command.to_user).to eq(9)
      end
    end
  end
end
