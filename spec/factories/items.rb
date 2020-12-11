FactoryBot.define do
  factory :item do
    name { Faker::Games::Zelda.item }
    description { Faker::Games::StreetFighter.unique.quote }
    unit_price { (rand * 1000).round(2) }
    merchant
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
