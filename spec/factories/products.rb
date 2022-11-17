require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :product do
    productName { Faker::Name.name }
    cost { 5 }
    amountAvailable { Faker::Number.within(range: 1..10) }
    seller { User.new(email:'seller@store.com', password:'111111',role:"seller") }
  end
end
