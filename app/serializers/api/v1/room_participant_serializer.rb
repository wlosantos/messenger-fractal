module Api
  module V1
    class RoomParticipantSerializer < ActiveModel::Serializer
      attributes :id, :name, :email, :fractal_id, :moderator, :user_id, :room_id

      def name
        object.user.name
      end

      def email
        object.user.email
      end

      def fractal_id
        object.user.fractal_id
      end

      def moderator
        object.is_moderator
      end
    end
  end
end
