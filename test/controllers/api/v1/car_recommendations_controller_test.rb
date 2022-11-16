require 'test_helper'

class API::V1::CarRecommendationsControllerTest < ActionDispatch::IntegrationTest
  test 'get a list of cars' do
    get api_v1_car_recommendations_path(user_id: 1, page: 1)

    assert_response :success

    result = response.parsed_body
    cars = result['data']
    errors = result['errors']

    car_recommendations_file = fixture_file_upload('car_recommendations.json')
    expected_hash = JSON.parse(File.read(car_recommendations_file))

    assert_empty errors
    assert_equal cars.length, 20
    cars.each_with_index do |car, index|
      assert_equal expected_hash[index]['id'], car['id']
      assert_equal expected_hash[index]['brand'], car['brand']
      assert_equal expected_hash[index]['model'], car['model']
      assert_equal expected_hash[index]['price'], car['price']
      assert_equal expected_hash[index]['rank_score'].to_s, car['rank_score'].to_s
      assert_equal expected_hash[index]['label'].to_s, car['label'].to_s
    end
  end
end
