require 'spec_helper'

describe :PrivateMessageEventCommand do
  context :parse do
    describe 'when the command string does not match the format' do
      it 'returns nil' do
        expect(PrivateMessageEventCommand.parse('54|P|2')).to be_nil
      end
    end

    describe 'when the command string matches the format' do
      it 'returns nil for invalid sequence numbers' do
        expect(PrivateMessageEventCommand.parse('-1|P|2|3')).to be_nil
      end

      it 'returns a new follow command for valid commands' do
        command = PrivateMessageEventCommand.parse('1|P|2|3')

        expect(command).to_not be_nil
        expect(command.sequence).to eq(1)
        expect(command.from_user).to eq(2)
        expect(command.to_user).to eq(3)
      end
    end
  end
end
