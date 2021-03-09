class DailyWeather < WeatherSnapshot
  attr_reader :date,
              :sunrise,
              :sunset,
              :min_temp,
              :max_temp,
              :conditions,
              :icon

  def initialize(data, timezone_offset)
    @date = local_time(data[:dt], timezone_offset).split[0]
    @sunrise = local_time(data[:sunrise], timezone_offset)
    @sunset = local_time(data[:sunset], timezone_offset)
    @min_temp = data[:temp][:min]
    @max_temp = data[:temp][:max]
    super
  end
end
