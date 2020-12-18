class Error
  attr_reader :status, :detail

  def initialize(error_messages)
    @status = '400'
    @detail = error_messages
  end
end
