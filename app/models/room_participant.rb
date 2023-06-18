class RoomParticipant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :is_moderator, inclusion: { in: [true, false] }
  validates :is_blocked, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: :room_id }
end
