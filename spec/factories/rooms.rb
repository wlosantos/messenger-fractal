FactoryBot.define do
  factory :room do
    name { Faker::Lorem.sentences(number: 1).first }
    kind { %w[grupo privado direct].sample }
    read_only { false }
    moderator { nil }
    origin
    app
  end
end
