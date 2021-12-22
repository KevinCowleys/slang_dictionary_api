module Api
  module V1
    class AdminController < ApplicationController
      include ActionController::HttpAuthentication::Token

      MAX_PAGINATION_LIMIT = 20

      before_action :autheticate_user

      def index
        return render status: :unauthorized unless @user.is_admin

        slang = Slang.where(is_approved: false)
                     .includes(:user)
                     .limit(limit).offset(params[:offset]).order(created_at: :desc)
        render json: slang.as_json(include: :user, methods: %i[upvote_count downvote_count])
      end

      def approve
        return render status: :unauthorized unless @user.is_admin

        slang = Slang.find_by(id: params[:slang_id])
        return render status: :unprocessable_entity unless slang

        slang.is_approved = true

        if slang.save
          head :no_content
        else
          render status: :unprocessable_entity
        end
      end

      def destroy
        return render status: :unauthorized unless @user.is_admin

        slang = Slang.find_by(id: params[:slang_id])
        return render status: :unprocessable_entity unless slang

        if slang.destroy
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

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end
    end
  end
end
