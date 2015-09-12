require 'socket'

class Client
  attr_accessor :messages

  def initialize(id)
    @id = id
    @messages = []
    @stop = false
  end

  def register
    @socket = TCPSocket.open('localhost', 9099)
    @socket.puts "#{@id}\r\n"
  end

  def start
    loop do
      line = @socket.gets
      @messages << line.strip
      break if @stop
    end
    @socket.close
  end

  def stop
    @stop = true
  end
end
