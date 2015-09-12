class FollowActor

  def initialize(user_followers_manager, client_pool)
    @user_followers_manager = user_followers_manager
    @client_pool = client_pool
  end

  def act(command)
    @user_followers_manager.register_follower command.to_user, command.from_user
    begin
      @client_pool.notify(command.to_user, "Yay! User #{command.from_user} is now following you.")
    rescue ClientNotFoundError => e
      #log?
    end
    command.process!
  end
end
