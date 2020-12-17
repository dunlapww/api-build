class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.find_all(search_data)
    search_field = search_data.keys.first
    search_term = search_data[search_field]

    if search_field.to_s == 'name'
      Merchant.where("UPPER(#{search_field}) LIKE (?)", "%#{search_term.upcase}%")
    else
      Merchant.where("#{search_field} = ?", search_term)
    end
  end

  def self.most_revenue(quantity)
    Merchant.joins(invoices: %i[invoice_items transactions])
            .where('result = ?', 'success')
            .where('status = ?', 'shipped')
            .select('merchants.*, sum(invoice_items.quantity  * invoice_items.unit_price) as revenue')
            .group(:id)
            .order('revenue DESC')
            .limit(quantity)
  end

  def self.most_items(quantity)
    Merchant.joins(invoices: %i[invoice_items transactions])
            .where('result = ?', 'success')
            .where('status = ?', 'shipped')
            .select('merchants.*, sum(invoice_items.quantity) as total_items')
            .group(:id)
            .order('total_items DESC')
            .limit(quantity)
  end

  def self.revenue(id)
    # Merchant.joins(invoices: [:invoice_items, :transactions]).where("result = ?","success").where("status = ?","shipped").where("merchants.id = ?", "1").sum("invoice_items.quantity  * invoice_items.unit_price")
    Merchant.joins(invoices: %i[invoice_items transactions])
            .where('result = ?', 'success')
            .where('status = ?', 'shipped')
            .where('merchants.id = ?', id.to_s)
            .sum('invoice_items.quantity  * invoice_items.unit_price')
  end
end
