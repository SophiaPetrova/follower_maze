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
    if !@connected_clients.has_key? client_id
      raise ClientNotFoundError, "No client with id = #{client_id} exists in the pool"
    else
      begin
        @connected_clients[client_id].send message
      rescue StandardError => e
        @connected_clients.delete client_id
        App.log.error e
      end
    end
  end

  def broadcast(message)
    @connected_clients.keys.each do |key|
      notify(key, message)
    end
  end
end
