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
        dispatcher = EventsDispatcher.new([EventCommand])

        expect(dispatcher.dispatch(Events.new('1|D|12|9'))).to be false
      end
    end

    describe 'when the event has a valid payload' do
      let(:next_command_string) { '1|F|12|9' }
      let(:future_command_string) { '2|F|12|9' }

      let(:next_event_command) { FollowEventCommand.parse next_command_string }
      let(:future_event_command) { FollowEventCommand.parse future_command_string }

      it 'returns true' do
        dispatcher = EventsDispatcher.new([FollowEventCommand])

        expect(dispatcher.dispatch(Events.new(next_command_string))).to be true
      end

      it 'does not process the command if it is not the next' do
        expect(FollowEventCommand).to receive(:parse).and_return(future_event_command)
        dispatcher = EventsDispatcher.new([FollowEventCommand])

        expect(dispatcher.dispatch(Events.new(future_command_string))).to be true
        expect(future_event_command.processed).to be false
      end

      it 'processes the command if it is the next one in the stream' do
        expect(FollowEventCommand).to receive(:parse).and_return(next_event_command)
        dispatcher = EventsDispatcher.new([FollowEventCommand])

        expect(dispatcher.dispatch(Events.new(next_command_string))).to be true
        expect(next_event_command.processed).to be true
      end

      it 'processes all the sequential commands already seen' do
        expect(FollowEventCommand).to receive(:parse).and_return(future_event_command, next_event_command)
        dispatcher = EventsDispatcher.new([FollowEventCommand])

        expect(dispatcher.dispatch(Events.new(future_command_string))).to be true
        expect(future_event_command.processed).to be false

        expect(dispatcher.dispatch(Events.new(next_command_string))).to be true
        # processes until there is no matching sequence
        expect(next_event_command.processed).to be true
        expect(future_event_command.processed).to be true
      end
    end
  end
end
