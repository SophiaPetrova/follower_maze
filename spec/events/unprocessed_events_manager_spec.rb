require 'spec_helper'

describe :UnprocessedEventsManager do
  let(:event_command) { EventCommand.new 99 }
  let(:other_event_command) { EventCommand.new 98 }

  context :add do
    it 'saves the event to the buffer' do
      unprocessed_events = UnprocessedEventsManager.new
      unprocessed_events.add(event_command)

      expect(unprocessed_events.size).to eq(1)
    end

    it 'replaces the event with a newest version of it' do
      unprocessed_events = UnprocessedEventsManager.new

      unprocessed_events.add(event_command)
      unprocessed_events.add(event_command)
      expect(unprocessed_events.size).to eq(1)
    end

    it 'differentiates different events by the sequence number' do
      unprocessed_events = UnprocessedEventsManager.new

      unprocessed_events.add(event_command)
      unprocessed_events.add(other_event_command)
      expect(unprocessed_events.size).to eq(2)
    end
  end

  context :next_event do
    it 'returns nil if the next event does not exist in the buffer' do
      unprocessed_events = UnprocessedEventsManager.new

      unprocessed_events.add(event_command)
      expect(unprocessed_events.next_event event_command).to be_nil
    end

    it 'returns the next event if the next event exists in the buffer' do
      unprocessed_events = UnprocessedEventsManager.new

      unprocessed_events.add(event_command)
      expect(unprocessed_events.next_event other_event_command).to_not be_nil
    end
  end

  context :remove do
    it 'does nothing if the event does not exist in the buffer' do
      unprocessed_events = UnprocessedEventsManager.new
      unprocessed_events.add(event_command)

      unprocessed_events.remove(other_event_command)
      expect(unprocessed_events.size).to eq(1)
    end

    it 'removes the element' do
      unprocessed_events = UnprocessedEventsManager.new
      unprocessed_events.add(event_command)

      unprocessed_events.remove(EventCommand.new 99)
      expect(unprocessed_events.size).to eq(0)
    end
  end
end
