# frozen_string_literal: true

desc 'Fetch AI car recommendations'
task fetch_ai_car_recommendations: [:environment] do
  FetchCarRecommendationsJob.perform_now
end
