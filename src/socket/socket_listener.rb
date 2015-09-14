require 'socket'

class SocketListener
  def initialize(port, client_handler)
    @port = port
    @client_handler = client_handler
  end

  def start!
    Thread.new do
      server = TCPServer.open @port
      loop do
        process server.accept
        break if break?
      end
    end
  end

  private
  def break?
    !AppConfig.production?
  end

  def process(client)
    begin
      @client_handler.handle client
    rescue UserClientIdNotProvidedError
      #log?
    end
  end
end
