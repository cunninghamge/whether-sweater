class HourlyWeather < WeatherSnapshot
  attr_reader :time,
              :temperature,
              :conditions,
              :icon

  def initialize(data, timezone_offset)
    @time = local_time(data[:dt], timezone_offset).split[1]
    @temperature = data[:temp]
    super
  end
end
