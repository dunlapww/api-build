class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.find_all(search_data)
    return Merchant.where('name ILIKE (?)', "%#{search_data[:name]}%") if search_data[:name]
    return Merchant.where('created_at = (?)', search_data[:created_at]) if search_data[:created_at]
    return Merchant.where('updated_at = (?)', search_data[:updated_at]) if search_data[:updated_at]
    []
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

  def revenue
    Merchant.joins(invoices: %i[invoice_items transactions])
            .where('result = ?', 'success')
            .where('status = ?', 'shipped')
            .where('merchants.id = ?', id.to_s)
            .sum('invoice_items.quantity  * invoice_items.unit_price')
  end
end
