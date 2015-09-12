require 'spec_helper'

describe :UserClientSocketHandler do
  context :handle do
    let(:client_pool) { double('client_pool') }
    let(:client_socket) { double('client_socket') }
    let(:user_client_socket) { double('user_client_socket') }

    describe :errors do
      it 'if cannot read the id from the client' do
        expect(client_socket).to receive(:gets).and_return(nil)

        handler = UserClientSocketHandler.new client_pool
        expect { handler.handle(client_socket) } .to raise_error(UserClientIdNotProvidedError)
      end

      it 'if the id returned from the client is empty' do
        expect(client_socket).to receive(:gets).and_return("\n")

        handler = UserClientSocketHandler.new client_pool
        expect { handler.handle(client_socket) } .to raise_error(UserClientIdNotProvidedError)
      end
    end

    describe :succeeds do
      let(:protocol_message) { "123\r\n" }
      let(:id) { '123' }

      it 'registers a new user client socket with the received ID in the client pool' do
        expect(client_socket).to receive(:gets).and_return(protocol_message)
        expect(UserClientSocket).to receive(:new).and_return(user_client_socket)
        expect(client_pool).to receive(:register).with(id.to_i, user_client_socket)

        handler = UserClientSocketHandler.new client_pool
        handler.handle client_socket
      end
    end

  end
end
