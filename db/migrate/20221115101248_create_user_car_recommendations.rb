class CreateUserCarRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_car_recommendations do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :rank_score, precision: 5, scale: 4

      t.timestamps
    end
  end
end
