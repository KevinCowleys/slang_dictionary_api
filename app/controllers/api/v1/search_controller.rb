module Api
  module V1
    class SearchController < ApplicationController
      MAX_PAGINATION_LIMIT = 20

      def index
        slang = Slang.includes(:user)
                     .limit(limit).offset(params[:offset])
                     .search(params[:q])
        render json: slang.as_json(include: :user, methods: %i[upvote_count downvote_count])
      end

      private

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
          MAX_PAGINATION_LIMIT
        ].min
      end
    end
  end
end
