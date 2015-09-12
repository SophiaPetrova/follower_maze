class BroadcastActor

  def initialize(client_pool)
    @client_pool = client_pool
  end

  def act(command)
    begin
      @client_pool.broadcast 'my broadcast message'
    rescue ClientNotFoundError => e
      #log?
    end
    command.process!
  end
end
