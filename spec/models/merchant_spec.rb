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
      expect(Merchant.search('erch')).to eq([merchant1, merchant2])
      expect(Merchant.search('har')).to eq([merchant3])
      expect(Merchant.search('jsklsj')).to eq([])
    end
  end
end
