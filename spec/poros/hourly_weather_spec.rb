require 'rails_helper'

RSpec.describe HourlyWeather do
  it 'exists and has attributes' do
    tz_offset = -18000
    data = {
      dt: 1615327200,
      temp: 62.98,
      feels_like: 53.49,
      pressure: 1002,
      humidity: 11,
      dew_point: 10.29,
      uvi: 1.83,
      clouds: 100,
      visibility: 10000,
      wind_speed: 6.33,
      wind_deg: 39,
      weather: [
        {
          id: 804,
          main: "Clouds",
          description: "overcast clouds",
          icon: "04d"
        }
      ],
      pop: 0
    }
    snapshot = HourlyWeather.new(data, tz_offset)

    expect(snapshot).to be_a(HourlyWeather)
    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      time: local_time(data[:dt], tz_offset).split[1],
      temperature: data[:temp],
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
  end
end
