class BroadcastEventCommand < EventCommand
  def self.parse(command)
    return nil if REGEX.match(command).nil?
    tokens = command.split @@command_token_spearator

    BroadcastEventCommand.new(tokens[0].to_i)
  end

  def command
    "#{@sequence}\|B"
  end

  private
  REGEX = /^\d+\|B$/
end
