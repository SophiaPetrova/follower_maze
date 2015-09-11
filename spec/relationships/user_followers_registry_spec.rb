require 'spec_helper'

describe :UserFollowersRegistry do
  let(:user_being_followed) { 1 }
  let(:user_not_being_followed) { 2 }
  let(:follower) { 2 }
  let(:another_follower) { 3 }

  context :register_follower_for_user do
    it 'saves the new follower to the registry' do
      registry = UserFollowersRegistry.new
      registry.register_follower_for_user user_being_followed, follower

      expect(registry.get_followers(user_being_followed)).to match_array([follower])
    end

    it 'supports multiple followers' do
      registry = UserFollowersRegistry.new
      registry.register_follower_for_user user_being_followed, follower
      registry.register_follower_for_user user_being_followed, another_follower

      expect(registry.get_followers(user_being_followed)).to match_array([follower, another_follower])
    end

    it 'does not add the same follower again' do
      registry = UserFollowersRegistry.new
      registry.register_follower_for_user user_being_followed, follower
      registry.register_follower_for_user user_being_followed, follower

      expect(registry.get_followers(user_being_followed)).to match_array([follower])
    end
  end

  context :get_followers do
    it 'returns nil if the user is not in the registry' do
      registry = UserFollowersRegistry.new

      expect(registry.get_followers(user_not_being_followed)).to be_nil

    end
  end
end
