require 'spec_helper'

describe :EventsSocketHandler do
  context :handle do
    let(:dispatcher) { double('dispatcher') }
    let(:event) { double('event') }
    let(:events_socket) { double('events_socket') }
    let(:protocol_command) { "666|F|60|50\r\n" }
    let(:event_command) { '666|F|60|50' }

    describe 'closing the socket' do
      it 'when there is no message from the client' do
        expect(events_socket).to receive(:gets).and_return(nil)
        expect(events_socket).to receive(:close)

        handler = EventsSocketHandler.new
        handler.handle events_socket
      end

      it 'when the the message is empty the client' do
        expect(events_socket).to receive(:gets).and_return("\n")
        expect(events_socket).to receive(:close)

        handler = EventsSocketHandler.new
        handler.handle events_socket
      end

      it 'when there are no more messages' do
        expect(events_socket).to receive(:gets).twice.and_return(protocol_command, nil)
        expect(events_socket).to receive(:close)

        handler = EventsSocketHandler.new
        handler.handle events_socket
      end
    end

    describe 'dispatching' do
      it 'sends the events to the dispatcher' do
        expect(Events).to receive(:new).with(event_command).and_return(event)
        expect(dispatcher).to receive(:dispatch).with(event)
        expect(events_socket).to receive(:gets).and_return(protocol_command, nil)
        expect(events_socket).to receive(:close)

        handler = EventsSocketHandler.new dispatcher
        handler.handle events_socket
      end
    end
  end
end
