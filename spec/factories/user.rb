require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.user_name }
    password {"password"}
    password_confirmation {"password"}
  end
end