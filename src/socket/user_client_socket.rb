class UserClientSocket
  def initialize(socket)
    @socket = socket
  end

  def send(message)
    @socket.puts message
  end

  #close the socket?
end
