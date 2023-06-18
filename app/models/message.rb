class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id', optional: true

  enum moderation_status: { blank: 0, pending: 1, approved: 2, refused: 3 }

  validates :content, presence: true
end
