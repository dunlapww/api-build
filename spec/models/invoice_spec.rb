require 'rails_helper'

describe Invoice, type: :model do
  #direct from schema
  it {should belong_to :customer}
  it {should belong_to :merchant}

  #indirect from schema
  it {should have_many :invoice_items}
  it {should have_many(:items).through(:invoice_items)}
  it {should have_many :transactions}
end