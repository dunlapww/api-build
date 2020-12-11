require 'rails_helper'

describe Item, type: :model do
  describe 'relationships' do

    #indirect from schema
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should belong_to :merchant}
  end
end