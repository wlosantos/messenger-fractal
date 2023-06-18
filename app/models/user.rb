class User < ApplicationRecord
  rolify

  has_many :origin_rooms, class_name: 'Room', foreign_key: 'origin_id'
  has_many :moderator_rooms, class_name: 'Room', foreign_key: 'moderator_id'
  has_many :room_participants, dependent: :destroy
  has_many :rooms, through: :room_participants
  has_many :messages, dependent: :destroy

  validates :name, :email, :fractal_id, presence: true
  validates :email, :fractal_id, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :assign_default_role

  private

  def assign_default_role
    add_role(:admin) if User.count == 1
    add_role(:user) if roles.blank?
  end
end
