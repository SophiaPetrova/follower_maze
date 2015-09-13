require 'spec_helper'
require_relative 'client'
require_relative 'events_server'

describe 'A smoke test' do
  let(:follow_message) { '3|F|2|1' }
  let(:broadcast_message) { '2|B' }
  let(:private_message) { '1|P|3|1' }
  let(:first_status_update_message) { '4|S|1' }
  let(:unfollow_message) { '5|U|2|1' }
  let(:second_status_update_message) { '6|S|1' }
  let(:messages) { [follow_message, broadcast_message, private_message, first_status_update_message, unfollow_message, second_status_update_message] }

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
    expect(client_one_messages).to match_array([private_message, broadcast_message, follow_message])

    client_two_messages = client_two.messages
    expect(client_two_messages).to match_array([broadcast_message, first_status_update_message])

    client_three_messages = client_three.messages
    expect(client_three_messages).to match_array([broadcast_message])
  end
end
