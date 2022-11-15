class FetchCarRecommendationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    api_url = "https://bravado-images-production.s3.amazonaws.com"\
            "/recomended_cars.json?user_id="

    User.find_each do |user|
      response = Faraday.get(api_url + user.id.to_s)
      puts JSON.parse(response.body).inspect
    end
  end
end
