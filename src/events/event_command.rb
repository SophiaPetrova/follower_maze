class EventCommand
  attr_accessor :sequence, :from_user, :to_user

  def initialize(sequence, from_user = 0, to_user = 0)
    @sequence = sequence
    @from_user = from_user
    @to_user = to_user
    @@command_token_spearator = '|'
  end

  def parse(command)
    nil
  end


end
