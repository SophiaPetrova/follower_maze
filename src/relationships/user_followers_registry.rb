class UserFollowersRegistry

  def initialize
    @registry = {}
  end

  def register_follower_for_user(user_being_followed, new_follower)
    @registry[user_being_followed] = [] if !@registry.has_key? user_being_followed

    @registry[user_being_followed] << new_follower
    @registry[user_being_followed].uniq!
    true
  end

  def get_followers(user)
    @registry[user]
  end
end
