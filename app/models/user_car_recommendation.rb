# frozen_string_literal: true

class UserCarRecommendation < ApplicationRecord
  belongs_to :user
  belongs_to :car
end
