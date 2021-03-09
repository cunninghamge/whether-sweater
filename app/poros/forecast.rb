class Forecast
  def initialize(data)
    @timezone_offset = data[:timezone_offset]
    @current = data[:current]
    @daily = data[:daily]
    @hourly = data[:hourly]
  end

  def current_weather
    CurrentWeather.new(@current, @timezone_offset)
  end

  def daily_weather
    @daily[1..5].map do |day|
      DailyWeather.new(day, @timezone_offset)
    end
  end

  def hourly_weather
    @hourly[1..8].map do |hour|
      HourlyWeather.new(hour, @timezone_offset)
    end
  end
end
