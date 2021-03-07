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
    @conditions = data[:weather][0][:description]
    @icon = data[:weather][0][:icon]
    @sunrise = local_time(data[:sunrise], timezone_offset) if data[:sunrise]
    @sunset = local_time(data[:sunset], timezone_offset) if data[:sunset]
    @temperature = data[:temp] if data[:temp]
    remaining_fields = %i[min_temp max_temp feels_like humidity uvi visibility]
    remaining_fields.each do |field|
      instance_variable_set("@#{field}", data[field]) if data[field]
    end
  end

  def set_datetime(datetime, offset, datetime_opt)
    case datetime_opt
    when :datetime then @datetime = local_time(datetime, offset)
    when :date then @date = local_time(datetime, offset).split[0]
    when :time then @time = local_time(datetime, offset).split[1]
    end
  end

  def local_time(time, offset)
    Time.at(time).getlocal(offset).to_s
  end
end
