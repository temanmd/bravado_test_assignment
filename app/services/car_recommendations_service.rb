class CarRecommendationsService
  LABEL_PERFECT = :perfect_match
  LABEL_GOOD = :good_match
  LABEL_SORT_MAP = {
    0 => LABEL_PERFECT,
    1 => LABEL_GOOD
  }

  def initialize(params)
    @params = params
  end

  def perform
    @user = User.find(@params[:user_id])

    cars = get_all_recommended_cars()
    cars = filter_cars(cars)
    cars = sort_cars_sql(cars)
    cars = paginate_cars(cars)
    cars = collect_cars_fields(cars)

    { errors: [], data: cars }
  end

  private

  def get_all_recommended_cars
    recommended_cars = Car.includes(:brand, user_car_recommendations: [user: :preferred_brands])
                           .select(
                             'cars.*', :rank_score,
                             select_label_sql
                           )
                           .where(
                             user_car_recommendations: {
                               user_id: @params[:user_id]
                             }
                           )
    recommended_cars.or(Car.all)
  end

  def filter_cars(cars)
    if @params[:query].present?
      cars = cars.includes(:brand)
                 .where('brands.name ILIKE ?', "%#{@params[:query]}%")
                 .references(:brand)
    end
    if @params[:price_min].present?
      cars = cars.where('cars.price >= ?', @params[:price_min])
    end
    if @params[:price_max].present?
      cars = cars.where('cars.price <= ?', @params[:price_max])
    end

    cars
  end

  def collect_cars_fields(cars)
    cars.map do |car|
      car = car.attributes.slice('id', 'model', 'price', 'rank_score', 'label').merge({
        brand: {
          id: car.brand.id,
          name: car.brand.name
        }
      }).symbolize_keys

      # reorder keys
      {
        id: car[:id],
        brand: car[:brand],
        model: car[:model],
        price: car[:price],
        rank_score: car[:rank_score],
        label: LABEL_SORT_MAP[car[:label]]
      }
    end
  end

  def preferred_price_borders
    from = @user.preferred_price_range.first
    to = @user.preferred_price_range.last

    [from, to].join(',')
  end

  def preferred_brand_ids_sql
    UserPreferredBrand.where(user_id: 1).select(:brand_id).to_sql
  end

  def select_label_sql
    match_preferred_brands_sql = "brands.id = ANY (#{preferred_brand_ids_sql})"
    match_preffered_price_sql = "int8range(#{preferred_price_borders}) @> cars.price::int8"

    "CASE WHEN #{match_preferred_brands_sql} AND "\
              "#{match_preffered_price_sql} "\
              "THEN 0 "\
         "WHEN #{match_preferred_brands_sql} THEN 1 "\
         "ELSE 2 "\
    "END AS label"
  end

  def sort_cars_sql(cars)
    cars.order('8, rank_score DESC NULLS LAST, cars.price')
  end

  def paginate_cars(cars)
    Kaminari.paginate_array(cars).page(@params[:page])
  end
end
