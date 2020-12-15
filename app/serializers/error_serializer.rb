class ErrorSerializer
  def self.new(error_messages)
    json = {}
    json[:data] = {}
    json[:data][:attributes] = {}

    json[:data][:id] = '0'
    json[:data][:type] = 'Bad Request'
    json[:data][:attributes][:description] = error_messages
    json
  end
end
