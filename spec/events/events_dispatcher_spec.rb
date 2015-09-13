require 'spec_helper'

describe :EventsDispatcher do
  let(:events_command_builder) { double('events_command_builder') }
  let(:events_command_executor) { double('events_command_executor') }

  context :initialize do
    it 'sets the current processed command as sequence zero' do
      expect(EventCommand).to receive(:new).with(0, 'dummy-guard-command')
      EventsDispatcher.new events_command_builder, events_command_executor
    end
  end

  context :dispatch do
    let(:unprocessed_events_queue) { UnprocessedEventsQueue.new }

    describe 'when the event has an invalid payload' do
      it 'returns false' do
        expect(events_command_builder).to receive(:build_event_command).and_return(nil)
        dispatcher = EventsDispatcher.new(events_command_builder, events_command_executor)

        dispatched = dispatcher.dispatch(Events.new('1|D|12|9'))
        expect(dispatched).to be false
      end
    end

    describe 'when the event has a valid payload' do
      let(:next_command_string) { '1|F|12|9' }
      let(:future_command_string) { '2|F|12|9' }
      let(:dispatcher) { EventsDispatcher.new(events_command_builder, events_command_executor, unprocessed_events_queue) }
      let(:next_event_command) { FollowEventCommand.parse next_command_string }
      let(:future_event_command) { FollowEventCommand.parse future_command_string }

      it 'does not process the command if it is not the next' do
        expect(events_command_builder).to receive(:build_event_command).and_return(future_event_command)

        dispatched = dispatcher.dispatch(Events.new(future_command_string))
        expect(dispatched).to be true
        expect(future_event_command.processed).to be false
      end

      it 'processes the command if it is the next one in the stream' do
        expect(events_command_builder).to receive(:build_event_command).and_return(next_event_command)
        expect(events_command_executor).to receive(:execute).with(next_event_command)

        dispatched = dispatcher.dispatch(Events.new(next_command_string))
        expect(dispatched).to be true
      end

      it 'processes all the sequential commands already seen' do
        expect(events_command_builder).to receive(:build_event_command).and_return(future_event_command, next_event_command)
        expect(events_command_executor).to receive(:execute).with(next_event_command)
        expect(events_command_executor).to receive(:execute).with(future_event_command)

        future_dispatched = dispatcher.dispatch(Events.new(future_command_string))
        expect(future_dispatched).to be true

        next_dispatched = dispatcher.dispatch(Events.new(next_command_string))
        expect(next_dispatched).to be true
      end

      it 'removes the processed commands from the buffer' do
        expect(events_command_builder).to receive(:build_event_command).and_return(future_event_command, next_event_command)
        expect(events_command_executor).to receive(:execute).with(next_event_command)
        expect(events_command_executor).to receive(:execute).with(future_event_command)

        expect(unprocessed_events_queue.size).to eq(0)
        dispatcher.dispatch(Events.new(future_command_string))

        expect(unprocessed_events_queue.size).to eq(1)
        dispatcher.dispatch(Events.new(next_command_string))

        expect(unprocessed_events_queue.size).to eq(0)
      end
    end
  end
end
