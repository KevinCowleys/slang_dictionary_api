module Api
  module V1
    class SlangsController < ApplicationController
      include ActionController::HttpAuthentication::Token

      MAX_PAGINATION_LIMIT = 20

      before_action :autheticate_user, only: %i[create destroy]

      def index
        slang = Slang.where(is_approved: true)
                     .includes(:user)
                     .limit(limit).offset(params[:offset]).order(created_at: :desc)
        render json: slang.as_json(include: :user, methods: %i[upvote_count downvote_count])
      end

      def create
        slang = @user.slangs.new(slang_params)
        if slang.save
          render status: :created
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

      def slang_params
        params.require(:slang).permit(:word, :definition)
      end
    end
  end
end
