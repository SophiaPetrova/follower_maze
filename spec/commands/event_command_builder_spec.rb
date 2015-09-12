require 'spec_helper'

describe :EventCommandBuilder do
  let(:supported_command) { '1|B' }
  let(:unsupported_command) { '1|C' }
  let(:supported_event_command_type) { double('event_command') }
  let(:broadcast_event_command) { BroadcastEventCommand.new 1 }

  context :build_event_command do
    it 'returns nil if the command does not match any supported command' do
      expect(supported_event_command_type).to receive(:parse).with(unsupported_command).and_return(nil)

      builder = EventCommandBuilder.new ([supported_event_command_type])

      event_command = builder.build_event_command unsupported_command
      expect(event_command).to be_nil
    end

    it 'returns an event command object if the command matches one of the supported commands' do
      expect(supported_event_command_type).to receive(:parse).with(supported_command).and_return(broadcast_event_command)

      builder = EventCommandBuilder.new ([supported_event_command_type])

      event_command = builder.build_event_command supported_command
      expect(event_command).to eq(broadcast_event_command)
    end
  end
end
