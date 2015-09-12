require 'spec_helper'

describe :App do
  describe :start do
    # The class instances
    let(:client_pool) { double('clients_pool') }
    let(:user_followers_manager) { double('user_followers_manager') }
    let(:command_executor) { double('command_executor') }
    let(:command_builder) { double('command_builder') }
    let(:events_dispatcher) { double('events_dispatcher') }
    let(:events_handler) { double('events_handler') }
    let(:clients_handler) { double('clients_handler') }
    let(:clients_socket) { double('clients_socket') }
    let(:events_socket) { double('events_socket') }

    # The default event commands
    let(:broadcast_command) { double('broadcast_command') }
    let(:follow_command) { double('follow_command') }
    let(:private_message_command) { double('private_message_command') }
    let(:status_update_command) { double('status_update_command') }
    let(:unfollow_command) { double('unfollow_command') }

    # The default actors
    let(:broadcast_actor) { double('broadcast_actor') }
    let(:follow_actor) { double('follow_actor') }
    let(:private_message_actor) { double('private_message_actor') }
    let(:status_update_actor) { double('status_update_actor') }
    let(:unfollow_actor) { double('unfollow_actor') }

    # The default configurations
    let(:map) { {
      BroadcastEventCommand => broadcast_actor,
      FollowEventCommand => follow_actor,
      PrivateMessageEventCommand => private_message_actor,
      StatusUpdateEventCommand => status_update_actor,
      UnfollowEventCommand => unfollow_actor
    } }
    let(:commands) { map.keys }

    it 'creates all dependencies' do
      # The basic dependencies
      expect(ClientPool).to receive(:new).and_return(client_pool)
      expect(UserFollowersManager).to receive(:new).and_return(user_followers_manager)

      # The actors
      expect(BroadcastActor).to receive(:new).with(client_pool).and_return(broadcast_actor)
      expect(FollowActor).to receive(:new).with(user_followers_manager, client_pool).and_return(follow_actor)
      expect(PrivateMessageActor).to receive(:new).with(client_pool).and_return(private_message_actor)
      expect(StatusUpdateActor).to receive(:new).with(user_followers_manager, client_pool).and_return(status_update_actor)
      expect(UnfollowActor).to receive(:new).with(user_followers_manager).and_return(unfollow_actor)

      # The classes that do processing
      expect(EventCommandExecutor).to receive(:new).with(map).and_return(command_executor)
      expect(EventCommandBuilder).to receive(:new).with(commands).and_return(command_builder)
      expect(EventsDispatcher).to receive(:new).with(command_builder,command_executor).and_return(events_dispatcher)

      # The socket listeners
      expect(EventsSocketHandler).to receive(:new).with(events_dispatcher).and_return(events_handler)
      expect(UserClientSocketHandler).to receive(:new).with(client_pool).and_return(clients_handler)
      expect(SocketListener).to receive(:new).with(9090, events_handler).and_return(events_socket)
      expect(SocketListener).to receive(:new).with(9099, clients_handler).and_return(clients_socket)

      # The app bootstrap
      expect(events_socket).to receive(:start!)
      expect(clients_socket).to receive(:start!)

      app = App.new true #sets the stop flag to immediately stop
      app.start
    end
  end
end
