FactoryBot.define do

  month = Time.at(Time.now.to_f * rand()).month
  day = Time.at(Time.now.to_f * rand()).day
  exp_date = "#{month}/#{day}"

  factory :transaction do
    invoice
    credit_card_number {Faker::Finance.credit_card}
    credit_card_expiration_date {exp_date}
    result { "success" }
    created_at { Time.zone.today }
    updated_at { Time.zone.today }
  end
end
