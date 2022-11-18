require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    coin5 { Faker::Number.within(range: 1..20) }
    coin10 { Faker::Number.within(range: 1..20) }
    coin20 { Faker::Number.within(range: 1..20) }
    coin50 { Faker::Number.within(range: 1..20) }
    coin100 { Faker::Number.within(range: 1..20) }
    role { Faker::Number.within(range: 0..1) }
  end
end
