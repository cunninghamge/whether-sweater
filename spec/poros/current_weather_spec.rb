require 'rails_helper'

RSpec.describe CurrentWeather do
  it 'exists and has attributes' do
    tz_offset = -18000
    data = {
      dt: 1615047412,
      sunrise: 1615029583,
      sunset: 1615070808,
      temp: 16.57,
      feels_like: 7.88,
      pressure: 1016,
      humidity: 58,
      dew_point: 5.67,
      uvi: 2.15,
      clouds: 75,
      visibility: 10000,
      wind_speed: 4.61,
      wind_deg: 0,
      weather: [
        {
          id: 803,
          main: "Clouds",
          description: "broken clouds",
          icon: "04d"
          }
      ]
    }
    snapshot = CurrentWeather.new(data, tz_offset)

    expect(snapshot).to be_a(CurrentWeather)
    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      datetime: local_time(data[:dt], tz_offset),
      sunrise: local_time(data[:sunrise], tz_offset),
      sunset: local_time(data[:sunset], tz_offset),
      temperature: data[:temp],
      feels_like: data[:feels_like],
      humidity: data[:humidity],
      uvi: data[:uvi],
      visibility: data[:visibility],
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
  end
end
