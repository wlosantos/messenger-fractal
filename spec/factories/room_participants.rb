FactoryBot.define do
  factory :room_participant do
    is_moderator { false }
    is_blocked { false }
    user
    room
  end
end
