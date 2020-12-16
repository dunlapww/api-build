class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true

  def self.search(search_term)
    Merchant.where("UPPER(name) LIKE (?)","%#{search_term.upcase}%" )
  end
end
