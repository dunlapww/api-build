FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status {"shipped"}
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
