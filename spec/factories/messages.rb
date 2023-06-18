FactoryBot.define do
  factory :message do
    content { Faker::Lorem.paragraph(sentence_count: rand(2...8)) }
    moderation_status { %i[blank].sample }
    moderated_at { nil }
    refused_at { nil }
    user
    room

    trait :with_parent do
      parent { create(:message, room:) }
    end
  end
end
