class ErrorSerializer
  def self.new(error_messages)
    json = {}
    json[:errors] = [Error.new(error_messages)]
    json
  end
end
