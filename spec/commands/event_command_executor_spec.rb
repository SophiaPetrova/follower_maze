require 'spec_helper'

describe :EventCommandExecutor do
  let(:valid_command) { BroadcastEventCommand.new 1 }
  let(:actor) { double('an actor') }
  let(:executor) { EventCommandExecutor.new({ valid_command.class => actor }) }

  context :execute do
    it 'uses the appropriate actor to the command' do
      expect(actor).to receive(:act).with(valid_command)
      executor.execute valid_command
    end

    it 'does nothing if there is no mapping for command' do
      executor.execute StatusUpdateEventCommand.new(1, 2)
    end
  end
end
