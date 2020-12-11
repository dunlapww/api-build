require 'rails_helper'

describe InvoiceItem, type: :model do
  it {should belong_to :invoice}
  it {should belong_to :item}
end