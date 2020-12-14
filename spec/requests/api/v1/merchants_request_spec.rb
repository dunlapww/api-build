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

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant: merchant_params)
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

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant: merchant_params)

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:data].count).to eq(3)
    expect(error[:data][:id]).to eq(0)
    expect(error[:data][:type]).to eq('invalid request')
    expect(error[:data][:attributes].count).to eq(1)
    expect(error[:data][:attributes][:reasons]).to eq("Name can't be blank")
  end

  it 'can delete a merchant' do
    merchant = create(:merchant)
    merchant_params = { id: merchant.id }
    expect { delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    require 'pry'; binding.pry
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
