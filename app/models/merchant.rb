class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true

  def self.find_all(search_data)
    search_field = search_data.keys.first
    search_term = search_data[search_field]
    if search_field == :name
      Merchant.where("UPPER(#{search_field}) LIKE (?)", "%#{search_term.upcase}%")
    else
      Merchant.where("#{search_field} = ?", search_term)
    end
  end
end
