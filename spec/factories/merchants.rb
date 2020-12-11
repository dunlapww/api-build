FactoryBot.define do
  factory :merchant do
    name { Faker::Restaurant.name }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
