require 'spec_helper'

describe :PrivateMessageActor do
  let(:client_pool) { double('client_pool') }
  let(:destination_user) { 1 }
  let(:actor) { PrivateMessageActor.new client_pool }
  let(:message) { "1\|P\|1\|#{destination_user}" }
  let(:command) { PrivateMessageEventCommand.new 1, 1, destination_user }

  context :act do
    it 'sends the message to the client pool' do
      expect(client_pool).to receive(:notify).with(destination_user, message)
      actor.act(command)

      expect(command.processed).to be true
    end

    it 'ignores errors from the client pool' do
      expect(client_pool).to receive(:notify).with(destination_user, message).and_raise(ClientNotFoundError)
      actor.act(command)
      expect(command.processed).to be true
    end
  end
end
