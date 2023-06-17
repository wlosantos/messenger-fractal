FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { name.split(' ').join('-').downcase.to_s + "@#{Faker::Internet.domain_name}" }
    fractal_id { rand(1_001..9_999).to_s }

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end

    trait :user do
      after(:create) { |user| user.add_role(:user) }
    end
  end
end
