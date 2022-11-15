module API
  module V1
    class CarRecommendationsController < ApplicationController
      def index
        render json: []
      end
    end
  end
end
