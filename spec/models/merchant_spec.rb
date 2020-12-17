require 'rails_helper'

describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many :items }
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
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

      #an invoice_item for each invoice, low quantity and price to high quantity and price
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
    it '.search' do
      merchant1 = create(:merchant, name: "Great Merchant")
      merchant2 = create(:merchant, name: "Neat Merchant")
      merchant3 = create(:merchant, name: "Harold's")
      search_params = {name: 'erch'}
      expect(Merchant.find_all(search_params)).to eq([merchant1, merchant2])
      search_params = {name: 'har'}
      expect(Merchant.find_all(search_params)).to eq([merchant3])
      search_params = {name: 'jsklks'}
      expect(Merchant.find_all(search_params)).to eq([])

      ctime1 = "2020-12-16 03:21:52 UTC"
      ctime2 = "2020-12-14 03:21:52 UTC"
      utime1 = "2020-12-17 03:21:52 UTC"
      utime2 = "2020-12-15 03:21:52 UTC"
      merchant1 = create(:merchant, name: "Great Merchant", created_at: ctime1, updated_at: utime1)
      merchant2 = create(:merchant, name: "Neat Merchant", created_at: ctime1)
      merchant3 = create(:merchant, name: "Harold's", created_at: ctime2, updated_at: utime2)
      search_params = {created_at: ctime1}
      expect(Merchant.find_all(search_params)).to eq([merchant1, merchant2])
      search_params = {updated_at: utime2}
      expect(Merchant.find_all(search_params)).to eq([merchant3])
    end

    it '.most_revenue' do 
      expect(Merchant.most_revenue(3)).to eq([@m5, @m4, @m3])
    end

    it '.most_items' do
      ii7 = create(:invoice_item, invoice: @iv2, item: @it2, quantity: 100, unit_price: 2) #rev = $40
      ii8 = create(:invoice_item, invoice: @iv3, item: @it3, quantity: 120, unit_price: 3) #rev = $90
      ii9 = create(:invoice_item, invoice: @iv4, item: @it4, quantity: 140, unit_price: 4) #rev = $160
      expect(Merchant.most_items(3)).to eq([@m4, @m3, @m2])
    end
  end
end
