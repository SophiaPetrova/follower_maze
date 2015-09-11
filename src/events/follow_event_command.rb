class FollowEventCommand < EventCommand
  def self.parse(command)
    return nil if REGEX.match(command).nil?
    tokens = command.split @@command_token_spearator

    FollowEventCommand.new(tokens[0].to_i, tokens[2].to_i, tokens[3].to_i)
  end

  private
  REGEX = /^\d+\|F\|\d+\|\d+$/
end
