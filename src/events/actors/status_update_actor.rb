class StatusUpdateActor
  def initialize(user_followers_manager, client_pool)
    @user_followers_manager = user_followers_manager
    @client_pool = client_pool
  end

  def act(command)
    @user_followers_manager.get_followers(command.from_user).each do |follower|
      begin
        @client_pool.notify(follower, "Status update from #{command.from_user}: The brown fox...")
      rescue ClientNotFoundError => e
        #log?
      end
    end
    command.process!
  end
end
