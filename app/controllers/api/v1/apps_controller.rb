module Api
  module V1
    class AppsController < ApplicationController
      before_action :set_app, only: %i[show update destroy]

      def index
        app = App.all

        authorize app
        render json: app, status: :ok
      end

      def show
        app = App.find(params[:id])
        render json: app, status: :ok
      end

      def create
        app = App.new(app_params)
        authorize app

        if app.save
          render json: app, status: :created
        else
          render json: { errors: app.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize @app
        if @app.update(app_params)
          render json: @app, status: :ok
        else
          render json: { errors: @app.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @app
        @app.destroy
        head 204
      end

      private

      def set_app
        @app = App.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        head 404
      end

      def app_params
        params.require(:app).permit(:name)
      end
    end
  end
end
