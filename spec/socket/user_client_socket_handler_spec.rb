require 'spec_helper'

describe :UserClientSocketHandler do
  context :handle do
    let(:client_pool) { double('client_pool') }
    let(:client_socket) { double('client_socket') }
    let(:user_client_socket) { double('user_client_socket') }

    let(:protocol_message) { "123\r\n" }
    let(:id) { '123' }

    it 'registers a new user client socket with the received ID in the client pool' do
      expect(client_socket).to receive(:gets).and_return(protocol_message)
      expect(UserClientSocket).to receive(:new).and_return(user_client_socket)
      expect(client_pool).to receive(:register).with(id, user_client_socket)

      handler = UserClientSocketHandler.new client_pool
      handler.handle client_socket
    end
  end
end
