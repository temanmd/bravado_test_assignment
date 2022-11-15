class Car < ApplicationRecord
  belongs_to :brand
  has_many :user_car_recommendations
end
