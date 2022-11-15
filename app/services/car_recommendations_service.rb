class CarRecommendationsService
  LABEL_PERFECT = :perfect_match
  LABEL_GOOD = :good_match
  LABEL_SORT_MAP = {
    LABEL_PERFECT: 0,
    LABEL_GOOD: 1,
    nil: 2
  }

  def perform(params)
    puts User.all.inspect
    @user = User.find(params[:user_id])
    @recommended_cars = Car.includes(:user_car_recommendations)
                           .select('cars.*', :rank_score)
                           .where(
                             user_car_recommendations: {
                               user_id: params[:user_id]
                             }
                           )

    cars = @recommended_cars.or(Car.all)

    if params[:query].present?
      cars = cars.includes(:brand)
                 .where('brands.name ILIKE ?', "%#{params[:query]}%")
                 .references(:brand)
    end
    if params[:price_min].present?
      cars = cars.where('cars.price >= ?', params[:price_min])
    end
    if params[:price_max].present?
      cars = cars.where('cars.price <= ?', params[:price_max])
    end

    cars = cars.sort_by do |car|
      label = get_label(car)
      label_sort_value = LABEL_SORT_MAP[label]

      [label_sort_value, car.rank_score, car.price]
    end

    cars = Kaminari.paginate_array(cars).page(params[:page])

    { errors: [], data: cars }
  end

  private

  def get_label(car)
    match_preffered_brand = @user.preferred_brands.include?(car.brand)
    match_preffered_price = @user.preferred_price_range.include?(car.price)

    if match_preffered_brand
      return LABEL_PERFECT if match_preffered_price
      return LABEL_GOOD
    end
  end
end
