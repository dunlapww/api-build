require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of all merchants' do
    create_list(:item, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq(Merchant.name.downcase)
      merchant[:attributes] do |attribute|
        expect(attribute).to have_key(:name)
        expect(attribute[:name]).to be_a(String)
        expect(attribute[:created_at]).to be_a(String)
        expect(attribute).to have_key(:updated_at)
        expect(attribute[:updated_at]).to be_a(String)
      end
    end
  end
  it 'when there are no records in table it returns {:data=>[]}' do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants).to eq({ data: [] })
  end
  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    require 'pry'; binding.pry
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

  it 'can create a new merchant' do
    merchant_params = {
      name: 'McGuckins'
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
    expect(created_merchant.created_at).to be_a(Time)
    expect(created_merchant.updated_at).to be_a(Time)
  end

  it 'cannot create a new merchant if invalid data is provided' do
    merchant_params = {
      name: nil
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant_params)

    error = JSON.parse(response.body, symbolize_names: true)
    expect(error.count).to eq(1)
    expect(error[:errors].first[:status]).to eq("400")
    expect(error[:errors].first[:detail]).to eq("Name can't be blank")
  end

  it 'can delete a merchant' do
    merchant = create(:merchant)
    merchant_params = { id: merchant.id }
    expect { delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update a merchant' do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Great Merchant"}
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can get a merchant's items" do
    merchant_id = create(:merchant).id
    create_list(:item, 5, merchant_id: merchant_id)
    get "/api/v1/merchants/#{merchant_id}/items"
    
    expect(response).to be_successful
    
    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(5)
    
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

  it 'can return a list of merchants that contain a fragment of a name' do
   
    merchant1 = create(:merchant, name: "Great Merchant")
    merchant2 = create(:merchant, name: "Neat Merchant")
    merchant3 = create(:merchant, name: "Harold's")
    
    name_search_params = {
      name: 'erch'
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    get '/api/v1/merchants/find_all', headers: headers, params: name_search_params

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq(Merchant.name.downcase)
      merchant[:attributes] do |attribute|
        expect(attribute).to have_key(:name)
        expect(attribute[:name]).to eq(merchant1.name).or eq(merchant2.name)
        expect(attribute[:created_at]).to be_a(String)
        expect(attribute).to have_key(:updated_at)
        expect(attribute[:updated_at]).to be_a(String)
      end
    end
  end

  it 'can return a list of merchants that contain a fragment of a created_at time' do

    ctime1 = "2020-12-16 03:21:52 UTC"
    ctime2 = "2020-12-14 03:21:52 UTC"
    utime1 = "2020-12-17 03:21:52 UTC"
    utime2 = "2020-12-15 03:21:52 UTC"
    merchant1 = create(:merchant, name: "Great Merchant", created_at: ctime1, updated_at: utime1)
    merchant2 = create(:merchant, name: "Neat Merchant", created_at: ctime1)
    merchant3 = create(:merchant, name: "Harold's", created_at: ctime2, updated_at: utime2)

    created_search_params = {
      created_at: ctime1
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    get '/api/v1/merchants/find_all', headers: headers, params: created_search_params

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq(Merchant.name.downcase)
      merchant[:attributes] do |attribute|
        expect(attribute).to have_key(:name)
        expect(attribute[:name]).to eq(merchant1.name).or eq(merchant2.name)
        expect(attribute[:created_at]).to be_a(String)
        expect(attribute).to have_key(:updated_at)
        expect(attribute[:updated_at]).to be_a(String)
      end
    end
  end
  it 'can return a single merchant that contains a date or fragment of a name' do

    ctime1 = "2020-12-16 03:21:52 UTC"
    ctime2 = "2020-12-14 03:21:52 UTC"
    utime1 = "2020-12-17 03:21:52 UTC"
    utime2 = "2020-12-15 03:21:52 UTC"
    merchant1 = create(:merchant, name: "Great Merchant", created_at: ctime1, updated_at: utime1)
    merchant2 = create(:merchant, name: "Neat Merchant", created_at: ctime2)
    merchant3 = create(:merchant, name: "Harold's", created_at: ctime2, updated_at: utime2)

    created_search_params = {
      created_at: ctime1
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    get '/api/v1/merchants/find', headers: headers, params: created_search_params

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchant[:data].count).to eq(3)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:type]).to eq(Merchant.name.downcase)
    expect(merchant[:data][:attributes].count).to eq(3)
    merchant[:attributes] do |attribute|
      expect(attribute).to have_key(:name)
      expect(attribute[:name]).to eq(merchant1.name)
      expect(attribute[:created_at]).to be_a(String)
      expect(attribute).to have_key(:updated_at)
      expect(attribute[:updated_at]).to be_a(String)
    end
    
  end
end
