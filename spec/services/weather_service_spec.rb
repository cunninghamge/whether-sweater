require 'rails_helper'

RSpec.describe WeatherService do
  describe '.call' do
    it 'can get weather using a set of coordinates' do
      VCR.use_cassette('rutland') do
        lat = 43.610633
        lng = -72.972688

        data = WeatherService.call(lat, lng)
        expect(data).to be_a(Hash)
        check_hash_structure(data, :current, Hash)
        check_hash_structure(data[:current], :dt, Numeric)
        check_hash_structure(data[:current], :sunrise, Numeric)
        check_hash_structure(data[:current], :sunset, Numeric)
        check_hash_structure(data[:current], :temp, Numeric)
        expect(-50..120).to cover(data[:current][:temp])
        check_hash_structure(data[:current], :feels_like, Numeric)
        check_hash_structure(data[:current], :humidity, Numeric)
        check_hash_structure(data[:current], :uvi, Numeric)
        check_hash_structure(data[:current], :visibility, Numeric)
        check_hash_structure(data[:current], :weather, Array)
        expect(data[:current][:weather][0]).to be_a(Hash)
        check_hash_structure(data[:current][:weather][0], :description, String)
        check_hash_structure(data[:current][:weather][0], :icon, String)

        check_hash_structure(data, :hourly, Array)
        hour0 = data[:hourly][0]
        expect(hour0).to be_a(Hash)
        check_hash_structure(hour0, :dt, Numeric)
        check_hash_structure(hour0, :temp, Numeric)
        check_hash_structure(hour0, :weather, Array)
        expect(hour0[:weather][0]).to be_a(Hash)
        check_hash_structure(hour0[:weather][0], :description, String)
        check_hash_structure(hour0[:weather][0], :icon, String)

        check_hash_structure(data, :daily, Array)
        day0 = data[:daily][0]
        expect(day0).to be_a(Hash)
        check_hash_structure(day0, :dt, Numeric)
        check_hash_structure(day0, :sunrise, Numeric)
        check_hash_structure(day0, :sunset, Numeric)
        check_hash_structure(day0, :temp, Hash)
        check_hash_structure(day0[:temp], :min, Numeric)
        check_hash_structure(day0[:temp], :max, Numeric)
        check_hash_structure(day0, :weather, Array)
        expect(day0[:weather][0]).to be_a(Hash)
        check_hash_structure(day0[:weather][0], :description, String)
        check_hash_structure(day0[:weather][0], :icon, String)

        expect(data).not_to have_key(:minutely)
        expect(data).not_to have_key(:alerts)
      end
    end

    it 'can get weather for a different city' do
      VCR.use_cassette('bend_weather') do
        lat = 44.058088
        lng = -121.31515

        data = WeatherService.call(lat, lng)
        expect(data).to be_a(Hash)
        check_hash_structure(data, :current, Hash)
        check_hash_structure(data, :hourly, Array)
        check_hash_structure(data, :daily, Array)
      end
    end
  end
end
