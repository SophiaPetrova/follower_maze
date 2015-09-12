require 'spec_helper'
require_relative 'client'
require_relative 'events_server'

describe 'A smoke test' do
  let(:messages) { ['3|F|2|1', '2|B', '1|P|3|1', '4|S|1', '5|U|2|1', '6|S|1'] }

  it 'works!' do
    ENV.delete 'TEST'
    client_one = Client.new 1
    client_two = Client.new 2
    client_three = Client.new 3

    app = App.new
    Thread.new { app.start }

    events_server = EventsServer.new
    events_server.start

    client_one.register
    client_two.register
    client_three.register

    Thread.new { client_one.start }
    Thread.new { client_two.start }
    Thread.new { client_three.start }

    messages.each { |message| events_server.send(message) }
    sleep 0.5

    client_one.stop
    client_two.stop
    client_three.stop
    app.stop

    client_one_messages = client_one.messages
    expect(client_one_messages).to match_array(['my private message', 'my broadcast message', 'Yay! User 2 is now following you.'])

    client_two_messages = client_two.messages
    expect(client_two_messages).to match_array(['my broadcast message', 'Status update from 1: The brown fox...'])

    client_three_messages = client_three.messages
    expect(client_three_messages).to match_array(['my broadcast message'])
  end
end
