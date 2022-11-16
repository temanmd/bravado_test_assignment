module API
  module V1
    class CarRecommendationContract < Dry::Validation::Contract
      params do
        required(:user_id).filled(:integer)
        optional(:query).value(:string)
        optional(:price_min).value(:integer)
        optional(:price_max).value(:integer)
        optional(:page).value(:integer)
      end
    end
  end
end
