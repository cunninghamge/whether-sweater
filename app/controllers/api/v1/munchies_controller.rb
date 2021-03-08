class Api::V1::MunchiesController < ApplicationController
  def show
    route_time = route_time(munchie_params)
    arrival_time = Time.now + route_time[:route][:realTime]
    travel_time = route_time[:route][:formattedTime]
    restaurant_info = restaurant(munchie_params, arrival_time)
    forecast = forecast(params[:destination])
  end

  private

  def munchie_params
    params.permit(:start, :destination, :food)
  end

  def route_time(params)
    response = Faraday.get('http://www.mapquestapi.com/directions/v2/route') do |req|
      req.params[:key] = ENV['LOCATION_API_KEY']
      req.params[:from] = params[:start]
      req.params[:to] = params[:destination]
    end
    JSON.parse(response.body, symbolize_names: true)
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
    JSON.parse(response.body, symbolize_names: true)
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
