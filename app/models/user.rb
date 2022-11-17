# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_preferred_brands, dependent: :destroy
  has_many :preferred_brands, through: :user_preferred_brands,
                              source: :brand
  has_many :user_car_recommendations, dependent: :destroy
  has_many :recommended_cars, through: :user_car_recommendations,
                              source: :car
end
