class SocketListener
  def initialize(port, client_handler)
    @server = TCPServer.open port
    @client_handler = client_handler
  end

  def start!
    loop do
      Thread.start(@server.accept) do |client|
        process client
      end
      break if should_break?
    end
  end

  private
  def should_break?
    !AppConfig.is_production?
  end

  def process(client)
    @client_handler.handle client
  end
end
