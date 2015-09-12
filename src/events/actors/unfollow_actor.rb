class UnfollowActor

  def initialize(user_followers_manager)
    @user_followers_manager = user_followers_manager
  end

  def act(command)
    @user_followers_manager.remove_follower command.to_user, command.from_user
    command.process!
  end
end
