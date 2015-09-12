class PrivateMessageActor

  def initialize(client_pool)
    @client_pool = client_pool
  end

  def act(command)
    begin
      @client_pool.notify command.to_user, 'my private message'
    rescue ClientNotFoundError => e
      #log?
    end
    command.process!
  end

end
