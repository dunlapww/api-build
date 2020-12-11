require 'rails_helper'

describe Merchant, type: :model do
  describe 'relationships' do
    # indirect from schema
    it { should have_many :invoices }
    it { should have_many :items }
  end
end
