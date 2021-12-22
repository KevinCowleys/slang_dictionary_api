module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          render json: { "token": AuthenticationTokenService.encode(user.id)}, status: :created
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
    end
  end
end
