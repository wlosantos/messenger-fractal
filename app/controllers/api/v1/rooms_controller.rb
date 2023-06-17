module Api
  module V1
    class RoomsController < ApplicationController
      before_action :set_room, only: %i[show update destroy]

      def index
        app = App.find(params[:app_id])
        rooms = current_user.has_role?(:admin) ? Room.all : app.rooms.where(origin_id: current_user.id)

        authorize rooms
        render json: rooms, status: :ok
      end

      def show
        authorize @room
        render json: @room, serializer: RoomSerializer, show_messager: false, status: :ok
      end

      def create
        app = App.find(params[:app_id])

        return unless app

        room = Room.new(room_params.merge(origin_id: current_user.id, app_id: app.id))
        authorize room

        if room.save
          render json: room, status: :created
        else
          render json: { errors: room.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @room

        if @room.update(room_params)
          render json: @room, status: :ok
        else
          render json: { errors: @room.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @room

        @room.destroy
        head 204
      end

      private

      def set_room
        @room = Room.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head 404
      end

      def room_params
        params.require(:room).permit(:name, :room_type, :read_only)
      end
    end
  end
end
