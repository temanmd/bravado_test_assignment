require 'test_helper'

class API::V1::CarRecommendationsControllerTest < ActionDispatch::IntegrationTest
  test 'get a list of cars' do     
    get api_v1_car_recommendations_path(user_id: 1, page: 1)

    assert_response :success  
    
    response = JSON.parse(response.body)
    cars = response[:cars]
    errors = response[:errors]

    assert_empty errors
    assert_equal cars.length, 3
    assert_equal 'Volkswagen', cars.first.dig(:brand, :name)
  end
end
