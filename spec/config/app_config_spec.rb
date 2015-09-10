require 'spec_helper'

describe :AppConfig do
  context :is_production? do

    context 'when the there is a TEST environment variable' do
      it 'returns false' do
        ENV['TEST'] = 'true'
        expect(AppConfig.production?).to be false
      end
    end

    context 'when the there is no TEST environment variable' do
      it 'returns true' do
        ENV = []
        expect(AppConfig.production?).to be true
      end
    end
  end
end
