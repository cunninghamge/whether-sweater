class WeatherSnapshot
  attr_reader :conditions, :icon

  def initialize(data, timezone_offset)
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
  end

  def local_time(time, offset)
    Time.at(time).getlocal(offset).to_s
  end
end
