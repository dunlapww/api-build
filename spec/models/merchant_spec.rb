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
  end
end
