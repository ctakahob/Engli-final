require 'faker'

FactoryBot.define do
  factory :phrase do
    user 
    phrase { Faker::Name.unique.name }
    translation { Faker::Name.unique.name }
    category { 'Time' }
  end
end
