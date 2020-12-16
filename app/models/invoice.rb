class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  

  def self.revenue(start_date, end_date)
    Invoice.joins(:invoice_items, :transactions)
            .where("result = ?","success")
            .where("status = ?","shipped")
            .where(created_at: (Date.parse(start_date).beginning_of_day..Date.parse(end_date).end_of_day))
            .sum("invoice_items.quantity  * invoice_items.unit_price")    
  end

end
