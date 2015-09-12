require 'socket'

class EventsServer
  def start
    @socket = TCPSocket.open('localhost', 9090)
  end

  def stop
    @socket.close
  end

  def send(message)
    @socket.puts message
  end
end
