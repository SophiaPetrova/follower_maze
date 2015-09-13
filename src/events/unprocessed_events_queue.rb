class UnprocessedEventsQueue
  def initialize
    @unprocessed_events = {}
  end

  def add(event_command)
    @unprocessed_events[event_command.sequence] = event_command
  end

  def remove(event_command)
    @unprocessed_events.delete event_command.sequence
  end

  def size
    @unprocessed_events.keys.length
  end

  def next_event(event)
    return nil if !@unprocessed_events.has_key? event.next_command_sequence
    @unprocessed_events[event.next_command_sequence]
  end
end
