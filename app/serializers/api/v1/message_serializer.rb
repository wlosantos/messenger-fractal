module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      attributes :id, :room_id, :moderation_status, :content
    end
  end
end
