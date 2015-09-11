class UnprocessedEventsManager
  def initialize
    @unprocessed_events = {}
  end

  def add(event_command)
    @unprocessed_events[event_command.sequence] = event_command
  end

  def size
    @unprocessed_events.keys.length
  end
end
