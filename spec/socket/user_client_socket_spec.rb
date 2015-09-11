require 'spec_helper'

describe :UserClientSocket do
  let(:working_socket) { double('working_socket') }
  let(:message) { 'Hello, socket!' }

  context :send do
    it 'writes to the socket' do
      client_socket = UserClientSocket.new working_socket
      expect(working_socket).to receive(:puts).with(message)

      client_socket.send(message)
    end
  end
end
