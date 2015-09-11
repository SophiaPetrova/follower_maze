class EventsDispatcher

  def initialize(event_commands = [])
    @supported_events = event_commands
    @guard_command = EventCommand.new 0, 'dummy-guard-command'
  end

  def dispatch(event)
    matching_commands = @supported_events.select do |command|
      command.parse event.command
    end

    matching_commands.compact!
    return false if matching_commands.empty?
  end
end
