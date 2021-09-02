require 'faker'

FactoryBot.define do
  factory :example do
    user
    phrase
    example { Faker::Games::Dota.hero }
  end
end
