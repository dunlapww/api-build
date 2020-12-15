class Error
  attr_reader :error, :reasons

  def initialize(errors)
    @error = 'invalid request'
    @reasons = errors
  end
end
