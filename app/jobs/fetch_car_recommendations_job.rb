class FetchCarRecommendationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    api_url = "https://bravado-images-production.s3.amazonaws.com"\
            "/recomended_cars.json?user_id="

    User.find_each do |user|
      ActiveRecord::Base.transaction do
        response = Faraday.get(api_url + user.id.to_s)
        parsed_response = JSON.parse(response.body)

        parsed_response.each do |fetched_recommendation|
          recommendation = UserCarRecommendation.find_or_initialize_by(
            user: user,
            car_id: fetched_recommendation['car_id']
          )
          recommendation.rank_score = fetched_recommendation['rank_score'].to_f
          recommendation.save!
        end
      end
    end
  end
end
