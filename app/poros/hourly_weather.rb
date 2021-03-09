class HourlyWeather
  def initialize(data, timezone_offset)
    @time = local_time(data[:dt], timezone_offset).split[1]
    @temperature = data[:temp]
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
  end

  def local_time(time, timezone_offset)
    Time.at(time).getlocal(timezone_offset).to_s
  end
end
