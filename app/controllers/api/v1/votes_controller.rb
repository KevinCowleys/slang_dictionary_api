module Api
  module V1
    class VotesController < ApplicationController
      include ActionController::HttpAuthentication::Token

      before_action :autheticate_user

      def like
        slang_vote = @user.votes.where(slang_id: params[:slang_id]).first_or_initialize
        slang = Slang.find_by(id: params[:slang_id]).present?
        if (slang_vote.id.nil? || slang_vote.id) && slang
          if slang_vote.upvote == true
            slang_vote.destroy
            head :no_content
          else
            slang_vote.update(upvote: true)
            render status: :created
          end
        else
          render status: :unprocessable_entity
        end
      end

      def dislike
        slang_vote = @user.votes.where(slang_id: params[:slang_id]).first_or_initialize
        slang = Slang.find_by(id: params[:slang_id]).present?
        if (slang_vote.id.nil? || slang_vote.id) && slang
          if slang_vote.upvote == false
            slang_vote.destroy
            head :no_content
          else
            slang_vote.update(upvote: false)
            render status: :created
          end
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
    end
  end
end
