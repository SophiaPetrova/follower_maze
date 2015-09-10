require 'spec_helper'

describe :Socket do
  let(:client_handler) { double('client_handler') }

  context :initialize do
    let(:port) { 1 }
    it 'creates a new TCPServer in the specified port' do
      expect(TCPServer).to receive(:open).with port

      SocketListener.new port, client_handler
    end
  end

  context :start do
    let(:server) { double('server') }
    let(:socket) { double('socket') }
    let(:client) { double('client') }

    it 'processes every new client connected in a new thread' do
      expect(AppConfig).to receive(:is_production?).and_return(false)
      expect(TCPServer).to receive(:open).and_return(server)
      expect(server).to receive(:accept).and_return(socket)
      expect(Thread).to receive(:start).with(socket).and_yield(client)
      expect(client_handler).to receive(:handle).with(client)

      listener = SocketListener.new 1, client_handler
      listener.start!
    end
  end
end
