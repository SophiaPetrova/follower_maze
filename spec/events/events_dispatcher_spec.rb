require 'spec_helper'

describe :EventsDispatcher do
  context :initialize do
    it 'sets the current processed command as sequence zero' do
      expect(EventCommand).to receive(:new).with(0, 'dummy-guard-command')
      EventsDispatcher.new
    end
  end

  context :dispatch do
    describe 'when the event has an invalid payload' do
      it 'returns false' do
        dispatcher = EventsDispatcher.new([EventCommand.new(0, 'dummy-command')])

        expect(dispatcher.dispatch(Events.new('1|D|12|9'))).to be false
      end
    end

    describe 'when the event has a valid payload' do
      it 'processes the command if it is the next one' do

      end
    end
  end
end
