class EventsSocketHandler

  def initialize(dispatcher = EventsDispatcher.new)
    @dispatcher = dispatcher
  end

  def handle(events_socket)
    while event_command = events_socket.gets
      break if event_command.nil? || event_command.strip!.empty?

      @dispatcher.dispatch Events.new(event_command)
    end
    events_socket.close
  end
end
