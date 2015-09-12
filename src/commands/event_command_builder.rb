class EventCommandBuilder
  def initialize(supported_command_events = [])
    @supported_command_events = supported_command_events
  end

  def build_event_command(command)
    event_commands = @supported_command_events.collect do |supported_command|
      supported_command.parse command
    end

    event_commands.compact.first
  end
end
