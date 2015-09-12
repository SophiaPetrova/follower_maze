class UnfollowActor

  def initialize(user_followers_manager)
    @user_followers_manager = user_followers_manager
  end

  def act(user_being_followed, follower)
    @user_followers_manager.remove_follower user_being_followed, follower
  end
end
