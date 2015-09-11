require 'spec_helper'

describe :PrivateMessageActor do
  let(:client_pool) { double('client_pool') }
  let(:destination_user) { 1 }
  let(:actor) { PrivateMessageActor.new client_pool }
  let(:message) { 'my private message' }

  context :act do
    it 'sends the message to the client pool' do
      expect(client_pool).to receive(:notify).with(destination_user, message)
      actor.act(destination_user, message)
    end

    it 'ignores errors from the client pool' do
      expect(client_pool).to receive(:notify).with(destination_user, message).and_raise(ClientNotFoundError)
      actor.act(destination_user, message)
    end
  end
end
