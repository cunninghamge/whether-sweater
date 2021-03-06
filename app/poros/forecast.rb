class Forecast
  attr_reader :current_weather, :daily_weather, :hourly_weather

  def initialize(data)
    @timezone_offset = data[:timezone_offset]
    @current_weather = current(data[:current])
    @daily_weather = daily(data[:daily][0..4])
    @hourly_weather = hourly(data[:hourly][0..7])
  end

  def current(data)
    WeatherSnapshot.new(data, @timezone_offset, :datetime)
  end

  def daily(data)
    data.map do |day|
      fields = day.slice(:dt, :sunrise, :sunset, :weather).merge(day[:temp].slice(:min, :max))
      WeatherSnapshot.new(fields, @timezone_offset, :date)
    end
  end

  def hourly(data)
    data.map do |hour|
      fields = hour.slice(:dt, :temp, :weather)
      WeatherSnapshot.new(fields, @timezone_offset, :time)
    end
  end
end
