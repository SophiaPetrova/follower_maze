class EventsDispatcher

  def initialize(event_commands = [])
    @supported_events = event_commands
    @guard_command = EventCommand.new 0, 'dummy-guard-command'
    @unprocessed_commands = {}
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
      @unprocessed_commands[command.sequence] = command
    end

    while @unprocessed_commands.has_key? @guard_command.next_command_sequence
      processing_command = @unprocessed_commands[@guard_command.next_command_sequence]
      processing_command.process!
      @guard_command = processing_command
    end
  end
end
