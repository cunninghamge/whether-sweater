class MunchiesFacade
  class << self
    def munchie(params)
      route = RouteService.call(params[:start], params[:destination])
      restaurant = RestaurantService.call(
        params[:destination],
        params[:food],
        route[:realTime])
      forecast = CurrentWeatherService.call(params[:destination])
      Munchie.new(params[:destination], route[:formattedTime], forecast, restaurant)
    end
  end
end
