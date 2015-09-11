class ClientPool

  def initialize
    @connected_clients = {}
  end

  def register(client_id, client)
    @connected_clients[client_id] = client
  end

  def total_registered_clients
    @connected_clients.keys.length
  end

  def notify(client_id, message)
    raise ClientNotFoundError, "No client with id = #{client_id} exists in the pool" if !@connected_clients.has_key? client_id
    @connected_clients[client_id].send message
  end

end
