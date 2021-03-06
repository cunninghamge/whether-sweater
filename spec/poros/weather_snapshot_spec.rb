require 'rails_helper'

RSpec.describe WeatherSnapshot do
  it 'can be initialized with current weather data' do
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
    snapshot = WeatherSnapshot.new(data, tz_offset, :datetime)

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
    expect(snapshot.date).to be_nil
    expect(snapshot.time).to be_nil
    expect(snapshot.min_temp).to be_nil
    expect(snapshot.max_temp).to be_nil
  end

  it 'can be initialized with daily weather data' do
    tz_offset = -18000
    data = {
      dt: 1615050000,
      sunrise: 1615029583,
      sunset: 1615070808,
      min_temp: 4.28,
      max_temp: 21.49,
      weather: [
        {
          id: 804,
          main: "Clouds",
          description: "overcast clouds",
          icon: "04d"
          }
        ]
     }
    snapshot = WeatherSnapshot.new(data, tz_offset, :date)

    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      date: local_time(data[:dt], tz_offset).split[0],
      sunrise: local_time(data[:sunrise], tz_offset),
      sunset: local_time(data[:sunset], tz_offset),
      min_temp: data[:min_temp],
      max_temp: data[:max_temp],
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
    expect(snapshot.datetime).to be_nil
    expect(snapshot.time).to be_nil
    expect(snapshot.temperature).to be_nil
    expect(snapshot.feels_like).to be_nil
    expect(snapshot.humidity).to be_nil
    expect(snapshot.uvi).to be_nil
    expect(snapshot.visibility).to be_nil
  end

  it 'can be initialized with hourly weather data' do
    tz_offset = -18000
    data = {
      dt: 1615046400,
      temp: 16.57,
      weather: [
        {
          id: 803,
          main: "Clouds",
          description: "broken clouds",
          icon: "04d"
          }
        ]
    }
    snapshot = WeatherSnapshot.new(data, tz_offset, :time)

    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      time: local_time(data[:dt], tz_offset).split[1],
      temperature: data[:temp],
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
    expect(snapshot.datetime).to be_nil
    expect(snapshot.date).to be_nil
    expect(snapshot.sunrise).to be_nil
    expect(snapshot.sunset).to be_nil
    expect(snapshot.min_temp).to be_nil
    expect(snapshot.max_temp).to be_nil
    expect(snapshot.feels_like).to be_nil
    expect(snapshot.humidity).to be_nil
    expect(snapshot.uvi).to be_nil
    expect(snapshot.visibility).to be_nil
  end

  describe 'instance methods' do
    it '#local_time' do
      dt = 1615029583
      offset = -18000

      snapshot = WeatherSnapshot.new({ dt: 0, weather: [{}] }, 0, nil)

      expect(snapshot.local_time(dt, offset)).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
    end

    describe '#set_datetime' do
      it 'can set datetime' do
        dt = 1615029583
        offset = -18000

        snapshot = WeatherSnapshot.new({ dt: 0, weather: [{}] }, 0, nil)

        expect(snapshot.set_datetime(dt, offset, :datetime)).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
        expect(snapshot.date).to be_nil
        expect(snapshot.time).to be_nil
      end

      it 'can set date' do
        dt = 1615029583
        offset = -18000

        snapshot = WeatherSnapshot.new({ dt: 0, weather: [{}] }, 0, nil)

        expect(snapshot.set_datetime(dt, offset, :date)).to match(/^\d{4}-\d{2}-\d{2}$/)
        expect(snapshot.datetime).to be_nil
        expect(snapshot.time).to be_nil
      end

      it 'can set time' do
        dt = 1615029583
        offset = -18000

        snapshot = WeatherSnapshot.new({ dt: 0, weather: [{}] }, 0, nil)

        expect(snapshot.set_datetime(dt, offset, :time)).to match(/^\d{2}:\d{2}:\d{2}$/)
        expect(snapshot.datetime).to be_nil
        expect(snapshot.date).to be_nil
      end
    end
  end
end

def local_time(time, offset)
  Time.at(time).getlocal(offset).to_s
end
