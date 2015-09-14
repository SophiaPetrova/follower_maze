require 'spec_helper'

describe :ClientPool do
  let(:simple_client) { double('simple_client') }
  let(:another_client) { double('another_client') }
  let(:id) { 1 }
  let(:another_id) { 2 }
  let(:message) { 'Hello, socket!' }

  context :register do
    it 'registers a socket with an id' do
      pool = ClientPool.new

      pool.register(id, simple_client)
      expect(pool.total_registered_clients).to eq(1)
    end

    it 'updates the existing socket if the id is already registered' do
      pool = ClientPool.new

      pool.register(id, simple_client)
      pool.register(id, another_client)

      expect(pool.total_registered_clients).to eq(1)
    end
  end

  context :notify do
    it 'notifies the client based on the id' do
      expect(simple_client).to receive(:send).with(message)

      pool = ClientPool.new
      pool.register(id, simple_client)
      pool.notify(id, message)
    end

    it 'raises an error if there is no client registered with the id' do
      pool = ClientPool.new

      expect { pool.notify(id, message) }.to raise_error(ClientNotFoundError)
    end

    it 'removes the client from the connected clients if the send message fails' do
      expect(simple_client).to receive(:send).with(message).and_raise(StandardError)

      pool = ClientPool.new
      pool.register(id, simple_client)
      pool.notify(id, message)

      expect(pool.total_registered_clients).to eq(0)
    end
  end

  context :broadcast do
    it 'notifies all clients connected to the pool' do
      expect(simple_client).to receive(:send).with(message)
      expect(another_client).to receive(:send).with(message)

      pool = ClientPool.new
      pool.register(id, simple_client)
      pool.register(another_id, another_client)

      pool.broadcast(message)
    end
  end
end
