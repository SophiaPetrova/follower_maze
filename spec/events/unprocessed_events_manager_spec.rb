require 'spec_helper'

describe :UnprocessedEventsManager do
  context :add do
    it 'saves the event to the buffer' do
      unprocessed_events = UnprocessedEventsManager.new
      unprocessed_events.add(EventCommand.new 99)

      expect(unprocessed_events.size).to eq(1)
    end

    it 'replaces the event with a newest version of it' do
      unprocessed_events = UnprocessedEventsManager.new
      event_command = EventCommand.new 99

      unprocessed_events.add(event_command)
      unprocessed_events.add(event_command)
      expect(unprocessed_events.size).to eq(1)
    end

    it 'differentiates different events by the sequence number' do
      unprocessed_events = UnprocessedEventsManager.new
      event_command = EventCommand.new 99
      other_event_command = EventCommand.new 98

      unprocessed_events.add(event_command)
      unprocessed_events.add(other_event_command)
      expect(unprocessed_events.size).to eq(2)
    end
  end
end
