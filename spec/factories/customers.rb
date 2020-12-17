FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
