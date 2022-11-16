module API
  module V1
    class CarRecommendationsController < ApplicationController
      def index
        contract_result = CarRecommendationContract.new.call(actual_params.to_h)
        if contract_result.success?
          result = ::CarRecommendationsService.new(actual_params).perform()
          render json: { data: result[:data], errors: result[:errors] }
        else
          render json: { data: [], errors: contract_result.errors.to_h }
        end
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
