module API
  module V1
    class CarRecommendationsController < ApplicationController
      def index
        result = ::CarRecommendationsService.new.perform(actual_params)
        render json: { data: result[:data], errors: result[:errors] }
      end

      private

      def actual_params
        params.permit(
          :user_id,
          :query,
          :price_min,
          :price_max,
          :page
        )
      end
    end
  end
end
