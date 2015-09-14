require 'spec_helper'

describe :SocketListener do
  let(:client_handler) { double('client_handler') }

  context :start do
    let(:port) { 1 }
    let(:server) { double('server') }
    let(:socket) { double('socket') }

    it 'processes every new client' do
      expect(AppConfig).to receive(:production?).and_return(false)
      expect(TCPServer).to receive(:open).with(port).and_return(server)
      expect(server).to receive(:accept).and_return(socket)
      expect(client_handler).to receive(:handle).with(socket)

      listener = SocketListener.new port, client_handler
      thread = listener.start!
      thread.join
    end

    it 'does not break if the handler fails to handle a new client' do
      expect(AppConfig).to receive(:production?).and_return(false)
      expect(TCPServer).to receive(:open).with(port).and_return(server)
      expect(server).to receive(:accept).and_return(socket)
      expect(client_handler).to receive(:handle).and_raise(UserClientIdNotProvidedError)

      listener = SocketListener.new port, client_handler
      thread = listener.start!
      thread.join
    end
  end
end
