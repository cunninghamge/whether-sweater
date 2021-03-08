class Munchie
  attr_reader :destination_city,
              :travel_time,
              :forecast,
              :restaurant


  def initialize(destination, travel_time, forecast, restaurant)
    @destination_city = format_destination(destination)
    @travel_time = format_travel_time(travel_time)
    @forecast = format_forecast(forecast)
    @restaurant = format_restaurant(restaurant)
  end

  def format_destination(destination)
    city = destination.split(',')
    city[0].capitalize!
    city[1].upcase!
    city*', '
  end

  def format_travel_time(travel_time)
    time = travel_time.split(':').map(&:to_i)
    "#{time[0]} #{'hour'.pluralize(time[0])}, #{time[1]} #{'minute'.pluralize(time[1])}"
  end

  def format_forecast(forecast)
    {
      summary: forecast[:weather][0][:description],
      temperature: forecast[:main][:temp]
    }
  end

  def format_restaurant(restaurant)
    {
      name: restaurant[:name],
      address: restaurant[:location][:display_address]*', '
    }
  end
end
