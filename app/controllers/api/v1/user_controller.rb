module Api
  module V1
    class UserController < ApplicationController
      include ActionController::HttpAuthentication::Token

      MAX_PAGINATION_LIMIT = 20

      before_action :autheticate_user_index, only: :index
      before_action :autheticate_user, only: %i[settings settings_update]

      def index
        user = User.find_by(username: params[:username].downcase)
        return render status: :unprocessable_entity unless user

        slangs = Slang.where(user_id: user.id)
                      .where(is_approved: true)
                      .includes(:user, :votes)
                      .limit(limit).offset(params[:offset]).order(created_at: :desc)

        if @user && (@user.id == user.id || @user.is_admin)
          slangs = Slang.where(user_id: @user.id)
                        .includes(:user)
                        .limit(limit).offset(params[:offset]).order(created_at: :desc)
                        .as_json(include: :user, methods: %i[upvote_count downvote_count])
          render json: slangs
        else
          render json: slangs.as_json(include: :user, methods: %i[upvote_count downvote_count])
        end
      end

      def settings
        user = @user.as_json
        # Need to delete here, doesn't save settings when @user has missing fields
        user.delete('email')
        user.delete('password_digest')
        render json: user
      end

      def settings_update
        if @user.update(user_params)
          head :no_content
        else
          render status: :unprocessable_entity
        end
      end

      private

      def autheticate_user
        token, _options = token_and_options(request)
        user_id = AuthenticationTokenService.decode(token)
        @user = User.find(user_id)
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render status: :unauthorized
      end

      def autheticate_user_index
        token, _options = token_and_options(request)
        user_id = AuthenticationTokenService.decode(token)
        @user = User.select(:id, :username, :is_admin).find(user_id)
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        @user = nil
      end

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end

      def user_params
        params.require(:user).permit(:username)
      end
    end
  end
end
