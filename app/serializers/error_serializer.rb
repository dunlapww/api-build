class ErrorSerializer
  def self.new(error)
    json = {}
    json[:data] = {}
    json[:data][:attributes] = {}
    
    json[:data][:id] = 0
    json[:data][:type] = error.error
    json[:data][:attributes][:reasons] = error.reasons
    json
  end
end
