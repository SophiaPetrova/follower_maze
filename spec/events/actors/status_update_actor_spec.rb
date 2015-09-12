require 'spec_helper'

describe :StatusUpdateActor do
  let(:client_pool) { double('client_pool') }
  let(:user_followers_manager) { double('user_followers_manager') }
  let(:user_being_followed) { 1 }
  let(:one_follower) { 2 }
  let(:another_follower) { 3 }
  let(:message) { 'Status update from 1: The brown fox...' }
  let(:command) { StatusUpdateEventCommand.new 1, user_being_followed }

  context :act do
    it 'notifies all the followers with the status update' do
      expect(client_pool).to receive(:notify).with(one_follower, message)
      expect(client_pool).to receive(:notify).with(another_follower, message)
      expect(user_followers_manager).to receive(:get_followers).with(user_being_followed).and_return([one_follower, another_follower])

      actor = StatusUpdateActor.new user_followers_manager, client_pool
      actor.act command
      expect(command.processed).to be true
    end

    #other option would be to configure retries
    it 'ignores errors while trying to notify any of the followers' do
      expect(client_pool).to receive(:notify).with(one_follower, message)
      expect(client_pool).to receive(:notify).with(another_follower, message).and_raise(ClientNotFoundError)
      expect(user_followers_manager).to receive(:get_followers).with(user_being_followed).and_return([one_follower, another_follower])

      actor = StatusUpdateActor.new user_followers_manager, client_pool
      actor.act command

      expect(command.processed).to be true
    end

    it 'does nothing if the user has no followers' do
      expect(user_followers_manager).to receive(:get_followers).with(user_being_followed).and_return([])

      actor = StatusUpdateActor.new user_followers_manager, client_pool
      actor.act command
      expect(command.processed).to be true
    end
  end
end
