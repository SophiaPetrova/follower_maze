require 'spec_helper'

describe :EventCommand do
  let(:command_one) { EventCommand.new 1 }

  context :initialize do
    it 'sets default values' do
      expect(command_one.processed).to be false
    end
  end

  context :next_command_sequence do
    it 'uses its sequence number' do
      expect(command_one.next_command_sequence).to eq(2)
    end
  end

  context :process! do
    it 'marks the event command as processed' do
      command_one.process!
      expect(command_one.processed).to be true
    end
  end

  context :parse do
    it 'returns nil' do
      expect(EventCommand.parse '1|U|12|9').to be_nil
    end
  end
end
