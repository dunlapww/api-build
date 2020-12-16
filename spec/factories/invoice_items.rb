FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity {rand(0..100)}
    unit_price { (rand * 1000).round(2) }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
