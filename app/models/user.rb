class User < ApplicationRecord
  rolify

  has_many :origin_rooms, class_name: 'Room', foreign_key: 'origin_id'
  has_many :moderator_rooms, class_name: 'Room', foreign_key: 'moderator_id'

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
