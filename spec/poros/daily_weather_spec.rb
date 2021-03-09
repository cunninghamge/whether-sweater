require 'rails_helper'

RSpec.describe DailyWeather do
  it 'exists and has attributes' do
    tz_offset = -18000
    data = {
      dt: 1615316400,
      sunrise: 1615296030,
      sunset: 1615338029,
      temp: {
        day: 59.36,
        min: 45.1,
        max: 62.98,
        night: 46.63,
        eve: 58.12,
        morn: 45.1
      },
      feels_like: {
        day: 52.41,
        night: 38.48,
        eve: 49.66,
        morn: 37.33
      },
      pressure: 1007,
      humidity: 31,
      dew_point: 20.97,
      wind_speed: 5.19,
      wind_deg: 351,
      weather: [
        {
        id: 804,
        main: "Clouds",
        description: "overcast clouds",
        icon: "04d"
        }
      ],
      clouds: 100,
      pop: 0.15,
      uvi: 4.56
    }
    snapshot = DailyWeather.new(data, tz_offset)

    expect(snapshot).to be_a(DailyWeather)
    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      date: local_time(data[:dt], tz_offset).split[0],
      sunrise: local_time(data[:sunrise], tz_offset),
      sunset: local_time(data[:sunset], tz_offset),
      min_temp: data[:temp][:min],
      max_temp: data[:temp][:max],
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
  end
end

def local_time(time, offset)
  Time.at(time).getlocal(offset).to_s
end
