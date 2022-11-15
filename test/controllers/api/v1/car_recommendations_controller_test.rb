require 'test_helper'

class API::V1::CarRecommendationsControllerTest < ActionDispatch::IntegrationTest
  test 'get a list of cars' do     
    get api_v1_car_recommendations_path

    assert_response :success  
    
    cars = JSON.parse(response.body)
      
    assert_equal cars.length, 3
    assert_equal 'Volkswagen', cars.first.dig(:brand, :name)
  end
end
