FactoryBot.define do
  factory :bank do
    name { Faker::Bank.name }
  end
end
