class MunchiesFacade
  class << self
    def munchie(params)
      route = RouteService.call(params[:start], params[:destination])
      arrival_time = Time.now + route[:realTime]
      travel_time = route[:formattedTime]
      restaurant_info = restaurant(params, arrival_time).slice(:name, :location)
      forecast_info = forecast(params[:destination]).slice(:weather, :main)
      Munchie.new(params[:destination], travel_time, forecast_info, restaurant_info)
    end

    def restaurant(params, arrival_time)
      response = Faraday.get('https://api.yelp.com/v3/businesses/search') do |req|
        req.params[:categories] = :restaurant
        req.params[:limit] = 1
        req.params[:term] = params[:food]
        req.params[:location] = params[:destination]
        req.params[:open_at] = arrival_time.to_i
        req.headers[:Authorization] = "Bearer #{ENV['YELP_API_KEY']}"
      end
      JSON.parse(response.body, symbolize_names: true)[:businesses][0]
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
