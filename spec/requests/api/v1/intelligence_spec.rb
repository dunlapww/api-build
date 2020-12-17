require 'rails_helper'

describe 'As a user' do
  describe 'I can request business intelligence reports' do
    before :each do
      #6 merchants
      @m1, @m2, @m3, @m4, @m5, @m6 = create_list(:merchant, 6)
      
      #an item created for each merchant
      @it1 = create(:item, merchant: @m1)
      @it2 = create(:item, merchant: @m2)
      @it3 = create(:item, merchant: @m3)
      @it4 = create(:item, merchant: @m4)
      @it5 = create(:item, merchant: @m6)
      @it6 = create(:item, merchant: @m6)

      #an invoice for each merchant
      @iv1 = create(:invoice, merchant: @m1, status: 'shipped', created_at: '2020-01-01T00:00:00 UTC')
      @iv2 = create(:invoice, merchant: @m2, status: 'shipped', created_at: '2020-01-02T00:00:00 UTC')
      @iv3 = create(:invoice, merchant: @m3, status: 'shipped', created_at: '2020-01-03T00:00:00 UTC')
      @iv4 = create(:invoice, merchant: @m4, status: 'shipped', created_at: '2020-01-04T00:00:00 UTC')
      @iv5 = create(:invoice, merchant: @m5, status: 'shipped', created_at: '2020-01-05T08:00:00 UTC') #8am to ensure end date capturing that day's shipped
      @iv6 = create(:invoice, merchant: @m6, status: 'packaged', created_at: '2020-01-06T00:00:00 UTC')

      #an invoice_item for each invoice, low quantity and prie to high quantity and price
      @ii1 = create(:invoice_item, invoice: @iv1, item: @it1, quantity: 10, unit_price: 1) #rev = $10
      @ii2 = create(:invoice_item, invoice: @iv2, item: @it2, quantity: 20, unit_price: 2) #rev = $40
      @ii3 = create(:invoice_item, invoice: @iv3, item: @it3, quantity: 30, unit_price: 3) #rev = $90
      @ii4 = create(:invoice_item, invoice: @iv4, item: @it4, quantity: 40, unit_price: 4) #rev = $160
      @ii5 = create(:invoice_item, invoice: @iv5, item: @it5, quantity: 50, unit_price: 5) #rev = $250
      @ii6 = create(:invoice_item, invoice: @iv6, item: @it6, quantity: 60, unit_price: 6) #rev = $360 (will not count as revenue because invoice not shipped)

      #a transaction for each invoice
      @t1 = create(:transaction, invoice: @iv1, result: 'success')
      @t2 = create(:transaction, invoice: @iv2, result: 'success')
      @t3 = create(:transaction, invoice: @iv3, result: 'success')
      @t4 = create(:transaction, invoice: @iv4, result: 'success')
      @t5 = create(:transaction, invoice: @iv5, result: 'success')
      @t6 = create(:transaction, invoice: @iv6, result: 'success')
    end
    it 'can return total revenue between a date range' do
      start_date = '2020-01-03'
      end_date = '2020-01-05'
      revenue_params = {start: start_date, end: end_date}

      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v1/revenue', headers: headers, params: revenue_params

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(json[:data][:attributes][:revenue].round(0)).to eq(500)
      expect(json[:data][:attributes][:start]).to eq(start_date)
      expect(json[:data][:attributes][:end]).to eq(end_date)
    end

    it 'most_revenue' do
      revenue_params = {quantity: 3}
      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v1/merchants/most_revenue', headers: headers, params: revenue_params
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(3)
      expect(json[:data].first[:id]).to be_a String
      expect(json[:data].first[:type]).to eq "merchant"
      expect(json[:data].first[:attributes]).to be_a Hash
      

    end
    it 'most_items' do
      ii7 = create(:invoice_item, invoice: @iv2, item: @it2, quantity: 100, unit_price: 2) 
      ii8 = create(:invoice_item, invoice: @iv3, item: @it3, quantity: 2000, unit_price: 3) 
      ii9 = create(:invoice_item, invoice: @iv4, item: @it4, quantity: 140, unit_price: 4)
      
      items_params = {quantity: 3}
      headers = { 'CONTENT_TYPE' => 'application/json' }

      get '/api/v1/merchants/most_items', headers: headers, params: items_params
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(3)
      expect(json[:data].first[:id]).to eq(@m3.id.to_s)
      expect(json[:data].first[:type]).to eq "merchant"
      expect(json[:data].first[:attributes][:name]).to eq(@m3.name)
      
      expect(json[:data][1][:id]).to eq(@m4.id.to_s)
      expect(json[:data][1][:type]).to eq "merchant"
      expect(json[:data][1][:attributes][:name]).to eq(@m4.name)
      
      expect(json[:data].last[:id]).to eq(@m2.id.to_s)
      expect(json[:data].last[:type]).to eq "merchant"
      expect(json[:data].last[:attributes][:name]).to eq(@m2.name)
      
    end
    it 'single merchant revenue' do
      
      headers = { 'CONTENT_TYPE' => 'application/json' }

      get "/api/v1/merchants/#{@m1.id}/revenue", headers: headers
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(json[:data].count).to eq(1)
      expect(json[:data][:attributes][:revenue]).to eq(10)
      expect(json[:data][:attributes][:merchant_id]).to eq(@m1.id.to_s)

    end
  end
end