class CurrentWeather
  def initialize(data, timezone_offset)
    @datetime = local_time(data[:dt], timezone_offset)
    @sunrise = local_time(data[:sunrise], timezone_offset)
    @sunset = local_time(data[:sunset], timezone_offset)
    @temperature = data[:temp]
    @feels_like = data[:feels_like]
    @humidity = data[:humidity]
    @uvi = data[:uvi]
    @visibility = data[:visibility]
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
  end

  def local_time(time, timezone_offset)
    Time.at(time).getlocal(timezone_offset).to_s
  end
end
