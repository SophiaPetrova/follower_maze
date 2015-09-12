class EventsDispatcher

  def initialize(events_command_builder, unprocessed_events_manager = UnprocessedEventsManager.new)
    @events_command_builder = events_command_builder
    @guard_command = EventCommand.new 0, 'dummy-guard-command'
    @unprocessed_commands = unprocessed_events_manager
  end

  def dispatch(event)
    command = @events_command_builder.build_event_command event.command
    return false if command.nil?
    process command

    true
  end

  private
  def process(new_command)
    @unprocessed_commands.add new_command

    while processing_command = @unprocessed_commands.next_event(@guard_command)
      processing_command.process!
      @guard_command = processing_command
      @unprocessed_commands.remove processing_command
    end
  end
end
