require 'rails_helper'

RSpec.describe WeatherFacade do
  it '.forecast' do
    VCR.use_cassette('rutland') do
      location = 'rutland,vt'
      expect(WeatherFacade).to receive(:geocode)
      .with(location)
      .and_call_original
      expect(LocationService).to receive(:call)
        .with(location)
        .and_call_original
      expect(WeatherService).to receive(:call).and_call_original

      forecast = WeatherFacade.forecast(location)

      expect(forecast).to be_a(Forecast)
    end
  end

  describe '.geocode' do
    it 'finds coordinates for a location' do
      VCR.use_cassette('bend') do
        location = 'bend,or'
        expect(LocationService).to receive(:call)
          .with(location)
          .and_call_original

        coordinates = WeatherFacade.geocode(location)
        expect(coordinates).to be_a(Hash)
        check_hash_structure(coordinates, :lat, Numeric)
        check_hash_structure(coordinates, :lng, Numeric)
      end
    end

    it 'returns nil if a location can\'t be found' do
      location = 'NOTAREALPLACE'
      allow(LocationService).to receive(:call).with(location).and_return(
        { results: [ { locations: [ {
            latLng: { lat: 39.390897, lng: -99.066067 }
        }] }] })

      coordinates = WeatherFacade.geocode(location)
      expect(coordinates).to be_nil
    end
  end
end
