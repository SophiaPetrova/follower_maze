require 'spec_helper'

describe :UserFollowersManager do
  let(:registry) { double('user_registry') }
  let(:user_being_followed) { 1 }
  let(:user_following) { 2 }

  context :register_follower do
    it 'stores the new follower for the provided user' do
      expect(registry).to receive(:register_follower_for_user).with(user_being_followed, user_following)

      user_followers_manager = UserFollowersManager.new registry
      user_followers_manager.register_follower user_being_followed, user_following
    end
  end

  context :get_followers do
    it 'returns the list of users' do
      expect(registry).to receive(:get_followers).with(user_being_followed).and_return([user_following])

      user_followers_manager = UserFollowersManager.new registry
      followers = user_followers_manager.get_followers(user_being_followed)

      expect(followers).to match_array([user_following])
    end

    it 'returns an empty list if the specified user has no followers' do
      expect(registry).to receive(:get_followers).with(user_being_followed).and_return(nil)

      user_followers_manager = UserFollowersManager.new registry
      followers = user_followers_manager.get_followers(user_being_followed)

      expect(followers).to be_empty
    end
  end

end
