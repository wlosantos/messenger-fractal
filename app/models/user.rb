class User < ApplicationRecord
  rolify

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
