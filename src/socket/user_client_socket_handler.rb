class UserClientSocketHandler
  def initialize(client_pool)
    @client_pool = client_pool
  end

  def handle(client_socket)
    client_id = client_socket.gets.strip
    @client_pool.register client_id, UserClientSocket.new(client_socket)
  end
end
