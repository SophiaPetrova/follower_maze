class EventsDispatcher

  def initialize(unprocessed_events_manager = UnprocessedEventsManager.new, event_commands = [])
    @supported_events = event_commands
    @guard_command = EventCommand.new 0, 'dummy-guard-command'
    @unprocessed_commands = unprocessed_events_manager
  end

  def dispatch(event)
    new_commands = @supported_events.collect do |command|
      command.parse event.command
    end

    new_commands.compact!
    return false if new_commands.empty?
    process new_commands

    true
  end

  private
  def process(new_commands)
    new_commands.each do |command|
      @unprocessed_commands.add command
    end

    while processing_command = @unprocessed_commands.next_event(@guard_command)
      processing_command.process!
      @guard_command = processing_command
      @unprocessed_commands.remove processing_command
    end
  end
end
