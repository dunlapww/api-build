require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(3)
    require 'pry'; binding.pry
    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float).or be_a(Integer)
      expect(item).to have_key(:created_at)
      expect(item[:created_at]).to be_a(String)
      expect(item).to have_key(:updated_at)
      expect(item[:updated_at]).to be_a(String)
    end
  end
end