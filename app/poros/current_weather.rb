class CurrentWeather < WeatherSnapshot
  attr_reader :datetime,
              :sunrise,
              :sunset,
              :temperature,
              :feels_like,
              :humidity,
              :uvi,
              :visibility,
              :conditions,
              :icon

  def initialize(data, timezone_offset)
    @datetime = local_time(data[:dt], timezone_offset)
    @sunrise = local_time(data[:sunrise], timezone_offset)
    @sunset = local_time(data[:sunset], timezone_offset)
    @temperature = data[:temp]
    @feels_like = data[:feels_like]
    @humidity = data[:humidity]
    @uvi = data[:uvi]
    @visibility = data[:visibility]
    super
  end
end
