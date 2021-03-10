require 'rails_helper'

RSpec.describe RoadTripFacade do
  it 'creates a RoadTrip object' do
    VCR.use_cassette('denver_to_seattle') do
      trip_params = {
        origin: 'Denver,CO',
        destination: 'Seattle,WA'
      }
      expect(RoadTripFacade).to receive(:build_trip).and_call_original
      expect(RoadTripFacade).to receive(:arrival_forecast).and_call_original
      expect(TripService).to receive(:call).and_call_original
      expect(WeatherService).to receive(:call).and_call_original

      road_trip = RoadTripFacade.road_trip(trip_params)

      expect(road_trip).to be_a(RoadTrip)
    end
  end

  it 'does not build a trip if the trip is impossible' do
    VCR.use_cassette('no_route') do
      trip_params = {
        origin: 'Denver,CO',
        destination: 'Berlin, DEU'
      }
      expect(TripService).to receive(:call).and_call_original
      expect(RoadTripFacade).not_to receive(:build_trip)
      expect(RoadTripFacade).not_to receive(:arrival_forecast)
      expect(WeatherService).not_to receive(:call)

      road_trip = RoadTripFacade.road_trip(trip_params)

      expect(road_trip).to be_a(RoadTrip)
    end
  end
end
