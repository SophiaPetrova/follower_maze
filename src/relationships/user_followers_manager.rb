class UserFollowersManager
  #Does not check for existance of the provided id

  def initialize(user_followers_registry = UserFollowersRegistry.new)
    @registry = user_followers_registry
  end

  def register_follower(user_being_followed, follower)
    @registry.register_follower_for_user user_being_followed, follower
  end

  def get_followers(user)
    followers = @registry.get_followers user
    followers.nil? ? [] : followers
  end
end
