class UnfollowEventCommand < EventCommand
  def self.parse(command)
    return nil if REGEX.match(command).nil?
    tokens = command.split @@command_token_spearator

    UnfollowEventCommand.new(tokens[0].to_i, tokens[2].to_i, tokens[3].to_i)
  end

  private
  REGEX = /^\d+\|U\|\d+\|\d+$/
end
