class Forecast
  attr_reader :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @current_weather = current(data[:current])
    @daily_weather = daily(data[:daily][0..4])
    @hourly_weather = hourly(data[:hourly][0..7])
  end

  def current(data)
    WeatherSnapshot.new(data)
  end

  def daily(data)
    data.map do |day|
      WeatherSnapshot.new(day)
    end
  end

  def hourly(data)
    data.map do |hour|
      WeatherSnapshot.new(hour)
    end
  end
end
