require 'spec_helper'

describe :UnfollowActor do
  let(:user_followers_manager) { double('user_followers_manager') }
  let(:user_being_followed) { 1 }
  let(:follower) { 2 }
  let(:command) { UnfollowEventCommand.new 1, follower, user_being_followed }

  context :act do
    it 'removes the follower in the followers manager' do
      expect(user_followers_manager).to receive(:remove_follower).with(user_being_followed, follower)
      actor = UnfollowActor.new user_followers_manager

      actor.act(command)
      expect(command.processed).to be true
    end
  end
end
