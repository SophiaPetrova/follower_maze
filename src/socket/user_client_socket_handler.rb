class UserClientSocketHandler
  def initialize(client_pool)
    @client_pool = client_pool
  end

  def handle(client_socket)
    protocol_message = client_socket.gets
    raise UserClientIdNotProvidedError.new, "Socked did not provide a client id" if protocol_message.nil? || protocol_message.strip.empty?

    client_id = protocol_message.strip
    @client_pool.register client_id, UserClientSocket.new(client_socket)
  end
end
