require 'spec_helper'

describe :ClientPool do
  let(:simple_client) { double('simple_client') }
  let(:another_client) { double('another_client') }
  let(:message) { 'Hello, socket!' }
  let(:id) { 1 }

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
  end
end
