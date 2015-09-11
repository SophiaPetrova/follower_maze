class PrivateMessageActor

  def initialize(client_pool)
    @client_pool = client_pool
  end

  def act(destination_user, message)
    begin
      @client_pool.notify destination_user, message
    rescue ClientNotFoundError => e
      #log?
    end
  end

end
