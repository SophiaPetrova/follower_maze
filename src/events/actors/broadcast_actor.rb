class BroadcastActor

  def initialize(client_pool)
    @client_pool = client_pool
  end

  def act(message)
    begin
      @client_pool.broadcast message
    rescue ClientNotFoundError => e
      #log?
    end
  end

end
