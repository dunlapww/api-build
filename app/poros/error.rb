class Error
  attr_reader :reasons

  def initialize(error_messages)
    @error_messages = error_messages
  end
end
