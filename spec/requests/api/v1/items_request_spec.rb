require 'rails_helper'

describe 'Items API' do
  it 'sends a list of all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(3)
    
    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:type]).to be_a(String)
      expect(item[:type]).to eq(Item.name.downcase)
      item[:attributes] do |attribute|
        expect(attribute).to have_key(:name)
        expect(attribute[:name]).to be_a(String)
        expect(attribute).to have_key(:description)
        expect(attribute[:description]).to be_a(String)
        expect(attribute).to have_key(:unit_price)
        expect(attribute[:unit_price]).to be_a(Float).or be_a(Integer)
        expect(attribute).to have_key(:created_at)
        expect(attribute[:created_at]).to be_a(String)
        expect(attribute).to have_key(:updated_at)
        expect(attribute[:updated_at]).to be_a(String)
      end
    end
  end
  it 'when there are no records in table it returns {:data=>[]}' do
    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items).to eq({:data=>[]})
  end

  it "can an return item's merchant" do
    merchant_id = create(:merchant).id
    item = create(:item, merchant_id: merchant_id)
    get "/api/v1/items/#{item.id}/merchants"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(merchant).to be_a(Hash)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq(Merchant.name.downcase)
    expect(merchant[:data]).to have_key(:attributes)

    expect(merchant[:data][:attributes]).to be_a(Hash)
    expect(merchant[:data][:attributes].count).to eq(3)

    merchant_dtl = merchant[:data][:attributes]

    expect(merchant_dtl).to have_key(:name)
    expect(merchant_dtl[:name]).to be_a(String)
    expect(merchant_dtl[:created_at]).to be_a(String)
    expect(merchant_dtl).to have_key(:updated_at)
    expect(merchant_dtl[:updated_at]).to be_a(String)
  end
end
