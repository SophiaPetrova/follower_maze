class EventCommandExecutor
  def initialize(event_command_to_actor_mapping = {})
    @event_command_to_actor_mapping = event_command_to_actor_mapping
  end

  def execute(command)
    actor = @event_command_to_actor_mapping[command.class]
    return if actor.nil?
    actor.act command
  end
end
