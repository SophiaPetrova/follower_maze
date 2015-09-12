require 'spec_helper'

describe :AppConfig do
  context :is_production? do
    let(:environment_variable) { 'TEST' }

    context 'when the there is a environment variable' do
      it 'returns false' do
        ENV[environment_variable] = 'true'
        expect(AppConfig.production?).to be false
      end
    end

    context 'when the there is not an environment variable' do
      it 'returns true' do
        ENV.delete environment_variable
        expect(AppConfig.production?).to be true
      end
    end
  end

  context :events_port do
    let(:event_listener_port) { '12345' }
    let(:environment_variable) { 'eventListenerPort' }

    context 'when the there is a envetListenerPort environment variable' do
      it 'returns the value of the variable' do
        ENV[environment_variable] = event_listener_port
        expect(AppConfig.events_port).to eq(event_listener_port.to_i)
      end
    end

    context 'when the there is not an environment variable' do
      it 'returns 9090' do
        ENV.delete environment_variable
        expect(AppConfig.events_port).to eq(9090)
      end
    end
  end

  context :clients_port do
    let(:clients_port) { '12345' }
    let(:environment_variable) { 'clientListenerPort' }

    context 'when the there is a envetListenerPort environment variable' do
      it 'returns the value of the variable' do
        ENV[environment_variable] = clients_port
        expect(AppConfig.clients_port).to eq(clients_port.to_i)
      end
    end

    context 'when the there is not an environment variable' do
      it 'returns 9099' do
        ENV.delete environment_variable
        expect(AppConfig.clients_port).to eq(9099)
      end
    end
  end
end
