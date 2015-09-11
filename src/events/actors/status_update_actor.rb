class StatusUpdateActor
  def initialize(user_followers_manager, client_pool)
    @user_followers_manager = user_followers_manager
    @client_pool = client_pool
  end

  def act(user_with_updated_status, message)
    @user_followers_manager.get_followers(user_with_updated_status).each do |follower|
      begin
        @client_pool.notify(follower, message)
      rescue ClientNotFoundError => e
        #log?
      end
    end
  end
end
