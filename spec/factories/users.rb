require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    # deposit { Faker::Number.within(range: 1..20) }
    # role { Faker::Number.number(range: 0..1) }
  end
end
