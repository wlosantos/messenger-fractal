module Api
  module V1
    class RoomSerializer < ActiveModel::Serializer
      attributes :id, :app_name, :name, :kind, :origin_id, :app_id, :read_only

      def app_name
        object.app.name
      end

      def list_participants
        object.room_participants.map do |room_participant|
          {
            user_id: room_participant.user_id,
            name: room_participant.user.name,
            moderator: room_participant.is_moderator
          }
        end
      end

      # def attributes(*args)
      #   hash = super
      #   if @instance_options[:show_messager]
      #     hash[:messages] = object.messages.map do |message|
      #       {
      #         id: message.id,
      #         author: message.user.name,
      #         content: message.content,
      #         created_at: message.created_at.strftime("%d/%m/%Y %H:%M:%S")
      #       }
      #     end
      #   end
      #   hash
      # end
    end
  end
end
