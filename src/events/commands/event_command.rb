class EventCommand
  attr_accessor :sequence, :from_user, :to_user, :processed
  @@command_token_spearator = '|'

  def initialize(sequence, from_user = 0, to_user = 0)
    @sequence = sequence
    @from_user = from_user
    @to_user = to_user
    @processed = false
  end

  def self.parse(command)
    nil
  end

  def process!
    @processed = true
    nil
  end

  def next_command_sequence
    @sequence + 1
  end

end
