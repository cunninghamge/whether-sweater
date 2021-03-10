class RoadTrip
  attr_reader :start_city,
              :end_city

  def initialize(params, travel_time = nil, forecast = nil)
    @start_city = params[:origin]
    @end_city = params[:destination]
    @time = travel_time
    @forecast = forecast
  end

  def travel_time
    return 'impossible' if @time.nil?

    time = @time.split(':').map(&:to_i)
    "#{time[0]} #{'hour'.pluralize(time[0])}, #{time[1]} #{'minute'.pluralize(time[1])}"
  end

  def weather_at_eta
    return {} if @forecast.nil?

    weather = { conditions: @forecast[:weather][0][:description] }
    weather[:temperature] = @forecast[:temp].try(:dig, :day) || @forecast[:temp]
    weather
  end
end
