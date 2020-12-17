class RevenueSerializer
  def self.new(revenue, query_params)
    json = {}
    json[:data] = {}
    json[:data][:attributes] = {}
    json[:data][:attributes][:revenue]=revenue
    query_params.each do |param, value|
      json[:data][:attributes][param.to_sym]=value
    end
    json
  end
  
end
