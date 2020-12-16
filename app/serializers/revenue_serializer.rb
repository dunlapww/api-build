class RevenueSerializer
  def self.new(revenue, start_date, end_date)
    json = {}
    json[:data] = {}
    json[:data][:attributes] = {}
    json[:data][:attributes][:start]=start_date
    json[:data][:attributes][:end]=end_date
    json[:data][:attributes][:revenue]=revenue
    json
  end
  
end
