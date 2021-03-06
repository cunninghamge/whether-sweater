class WeatherSnapshot
  attr_reader :datetime,
              :date,
              :time,
              :sunrise,
              :sunset,
              :temperature,
              :min_temp,
              :max_temp,
              :feels_like,
              :humidity,
              :uvi,
              :visibility,
              :conditions,
              :icon

  def initialize(data, timezone_offset, datetime)
    set_datetime(data[:dt], timezone_offset, datetime)
    @sunrise = local_time(data[:sunrise], timezone_offset) if data[:sunrise]
    @sunset = local_time(data[:sunset], timezone_offset) if data[:sunset]
    @temperature = data[:temp] if data[:temp]
    @min_temp = data[:min] if data[:min]
    @max_temp = data[:max] if data[:min]
    @feels_like = data[:feels_like] if data[:feels_like]
    @humidity = data[:humidity] if data[:feels_like]
    @uvi = data[:uvi] if data[:uvi]
    @visibility = data[:visibility] if data[:visibility]
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
  end

  def set_datetime(dt, offset, datetime_opt)
    if datetime_opt == :datetime
      @datetime = local_time(dt, offset)
    elsif datetime_opt == :date
      @date = local_time(dt, offset).split[0]
    elsif datetime_opt == :time
      @time = local_time(dt, offset).split[1]
    end
  end

  def local_time(time, offset)
    Time.at(time).getlocal(offset).to_s
  end
end
