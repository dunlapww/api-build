require 'rails_helper'

describe 'Items API' do
  it 'can return a list of merchant items' do
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
    expect(items).to eq({ data: [] })
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

  it 'it can get an item' do
    item = create(:item)

    get "/api/v1/items/#{item.id}"

    item_dtl = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_dtl[:data][:id]).to eq(item.id.to_s)
    expect(item_dtl[:data][:type]).to eq(Item.name.downcase)
    expect(item_dtl[:data][:attributes][:name]).to eq(item.name)
    expect(item_dtl[:data][:attributes][:description]).to eq(item.description)
    expect(item_dtl[:data][:attributes][:unit_price]).to eq(item.unit_price)
    expect(item_dtl[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
    expect(item_dtl[:data][:attributes][:created_at].to_date).to be_a Date
    expect(item_dtl[:data][:attributes][:updated_at].to_date).to be_a Date
  end

  it 'it can create an item' do
    merchant = create(:merchant)

    item_params = { name: 'Shoes',
                    description: 'Clown shoes',
                    unit_price: 5.93,
                    merchant_id: merchant.id }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    item_dtl = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_dtl[:data][:id].to_i).to eq(Item.last.id)
    expect(item_dtl[:data][:type]).to eq(Item.name.downcase)
    expect(item_dtl[:data][:attributes][:name]).to eq(item_params[:name])
    expect(item_dtl[:data][:attributes][:description]).to eq(item_params[:description])
    expect(item_dtl[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
    expect(item_dtl[:data][:attributes][:merchant_id]).to eq(item_params[:merchant_id])
    expect(item_dtl[:data][:attributes][:created_at].to_date).to be_a Date
    expect(item_dtl[:data][:attributes][:updated_at].to_date).to be_a Date
  end

  it 'can delete an item' do
    item = create(:item)
    expect { delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update an item' do
    merchant = create(:merchant)
    item = Item.create(name: 'best item', description: "it's the best", unit_price: 5.06, merchant_id: merchant.id)
    previous_name = Item.last.name
    merchant_params = { name: 'mediocre item', description: "actually, it's not that great", unit_price: 2.02 }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(merchant_params)
    updated_item = Item.find(item.id)

    expect(response).to be_successful
    expect(updated_item.name).to eq(merchant_params[:name])
    expect(updated_item.description).to eq(merchant_params[:description])
    expect(updated_item.unit_price).to eq(merchant_params[:unit_price])
    expect(updated_item.merchant_id).to eq(item.merchant_id)


    
  end

  it 'can return a list of items that contain a date or fragment of a name' do
    merchant = create(:merchant)
    item1 = create(:item, name: 'Great item', description: 'Super duper', unit_price: 2.01, created_at: '2020-12-17 17:31:25 -0700'.to_date)
    item2 = create(:item, name: 'Neat item', description: 'Dreamy', unit_price: 3.00, merchant_id: merchant.id)
    item3 = create(:item, name: 'a bucket', description: 'super for cleaning', merchant_id: merchant.id, updated_at: '2020-12-17 17:31:25 -0700'.to_date)

    headers = { 'CONTENT_TYPE' => 'application/json' }
    # name
    item_search_params = {
      name: 'Tem'
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item1.id, item2.id].sort

    # description
    item_search_params = {
      description: 'sup'
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item2.id, item3.id].sort

    # unit_price
    item_search_params = {
      unit_price: '2.01'
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(1)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item1.id].sort

    # merchant_id
    item_search_params = {
      merchant_id: merchant.id
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(2)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item2.id, item3.id].sort

    # created_at
    item_search_params = {
      created_at: '2020-12-17 17:31:25 -0700'.to_date
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(1)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item1.id].sort

    # updated_at
    item_search_params = {
      updated_at: '2020-12-17 17:31:25 -0700'.to_date
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(1)
    item_ids = items[:data].map { |item| item[:id] }.sort
    item_ids = [item3.id].sort

    # bad criteria
    item_search_params = {
      name: 'juniper'
    }

    get '/api/v1/items/find_all', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data]).to eq([])
  end
  it 'can find an item that matches a fragment of a name or description' do
    merchant = create(:merchant)
    item1 = create(:item, name: 'Great item', description: 'Super duper', unit_price: 2.01, created_at: '2020-12-17 17:31:25 -0700'.to_date)
    item2 = create(:item, name: 'Neat item', description: 'Dreamy', unit_price: 3.00, merchant_id: merchant.id)
    item3 = create(:item, name: 'a bucket', description: 'super for cleaning', merchant_id: merchant.id, updated_at: '2020-12-17 17:31:25 -0700'.to_date)

    headers = { 'CONTENT_TYPE' => 'application/json' }
    # name
    item_search_params = {
      name: 'tem'
    }

    get '/api/v1/items/find', headers: headers, params: item_search_params
    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data][:id].to_i).to eq(item1.id)
    expect(items[:data][:type]).to eq("item")
    expect(items[:data][:attributes][:name]).to eq(item1.name)
    expect(items[:data][:attributes][:description]).to eq(item1.description)
    expect(items[:data][:attributes][:unit_price]).to eq(item1.unit_price)
    expect(items[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
  end
end
