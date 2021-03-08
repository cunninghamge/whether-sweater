class MunchiesFacade
  class << self
    def munchie(params)
      route = RouteService.call(params[:start], params[:destination])
      travel_time = route[:formattedTime]
      restaurant = RestaurantService.call(params[:destination], params[:food], route[:realTime])
      forecast_info = forecast(params[:destination]).slice(:weather, :main)
      Munchie.new(params[:destination], travel_time, forecast_info, restaurant)
    end

    def forecast(destination)
      response = Faraday.get('https://api.openweathermap.org/data/2.5/weather') do |req|
        req.params[:q] = destination
        req.params[:units] = :imperial
        req.params[:appid] = ENV['WEATHER_API_KEY']
      end
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
