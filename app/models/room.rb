class Room < ApplicationRecord
  belongs_to :app
  belongs_to :origin, class_name: 'User', foreign_key: 'origin_id'
  belongs_to :moderator, class_name: 'User', foreign_key: 'moderator_id', optional: true

  enum kind: { grupo: 0, privado: 1, direct: 2 }

  validates :name, presence: true, uniqueness: { scope: :app_id }
  validates :kind, presence: true
end
