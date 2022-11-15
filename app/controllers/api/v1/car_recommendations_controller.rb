module API
  module V1
    class CarRecommendationsController < ApplicationController
      def index
        result = ::CarRecommendationsService.perform(actual_params)
        render json: { data: result.data, errors: result.errors }
      end

      private

      def actual_params
        params.permit(:user_id, :page)
      end
    end
  end
end
