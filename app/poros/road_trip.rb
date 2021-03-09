class RoadTrip
  attr_reader :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta

  def initialize(params, travel_time, forecast)
    @start_city = params[:origin]
    @end_city = params[:destination]
    @travel_time = format_time(travel_time)
    @weather_at_eta = {
      temperature: forecast[:temp],
      conditions: forecast[:weather][0][:description]
    }
  end

  def format_time(travel_time)
    time = travel_time.split(':').map(&:to_i)
    "#{time[0]} #{'hour'.pluralize(time[0])}, #{time[1]} #{'minute'.pluralize(time[1])}"
  end
end
