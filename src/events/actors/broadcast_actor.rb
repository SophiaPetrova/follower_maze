class BroadcastActor

  def initialize(client_pool)
    @client_pool = client_pool
  end

  def act(command)
    begin
      @client_pool.broadcast(command.command)
    rescue ClientNotFoundError => e
      #log?
    end
    command.process!
  end
end
