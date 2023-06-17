module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :autenticate!, only: :create

      def create
        dg_data = Users::DecodeService.call(user_params)

        if dg_data
          user = User.new(name: dg_data[:name], email: dg_data[:email], fractal_id: dg_data[:fractal_id])

          if user.save
            render json: { success: 'Welcome! You have signed up successfully.' }, status: :created
          else
            render json: { errors: user.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: dg_data }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:user_application_id, :datagateway_token, :url)
      end
    end
  end
end
