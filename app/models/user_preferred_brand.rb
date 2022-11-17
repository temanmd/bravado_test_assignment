# frozen_string_literal: true

class UserPreferredBrand < ApplicationRecord
  belongs_to :user
  belongs_to :brand
end
