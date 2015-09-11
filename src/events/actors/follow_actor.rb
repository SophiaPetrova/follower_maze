class FollowActor

  def initialize(user_followers_manager, client_pool)
    @user_followers_manager = user_followers_manager
    @client_pool = client_pool
  end

  def act(user_being_followed, new_follower)
    @user_followers_manager.register_follower user_being_followed, new_follower
    begin
      @client_pool.notify(user_being_followed, "Yay! User #{new_follower} is now following you.")
    rescue ClientNotFoundError => e
      #log?
    end
  end
end
