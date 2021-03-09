class DailyWeather
  def initialize(data, timezone_offset)
    @date = local_time(data[:dt], timezone_offset).split[0]
    @sunrise = local_time(data[:sunrise], timezone_offset)
    @sunset = local_time(data[:sunset], timezone_offset)
    @min_temp = data[:temp][:min]
    @max_temp = data[:temp][:max]
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
  end

  def local_time(time, timezone_offset)
    Time.at(time).getlocal(timezone_offset).to_s
  end
end
