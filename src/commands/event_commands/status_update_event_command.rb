class StatusUpdateEventCommand < EventCommand
  def self.parse(command)
    return nil if REGEX.match(command).nil?
    tokens = command.split @@command_token_spearator

    StatusUpdateEventCommand.new(tokens[0].to_i, tokens[2].to_i)
  end

  private
  REGEX = /^\d+\|S\|\d+$/
end
