class RoadTripFacade
  class << self
    def road_trip(params)
      trip_info = TripService.call(params)
      if trip_info[:info][:messages].empty?
        build_trip(trip_info, params)
      else
        RoadTrip.new(params)
      end
    end

    def build_trip(trip_info, params)
      coordinates = trip_info[:route][:locations][1][:latLng]
      forecast = arrival_forecast(coordinates, trip_info[:route][:time])
      RoadTrip.new(params, trip_info[:route][:formattedTime], forecast)
    end

    def arrival_forecast(coordinates, trip_time)
      data = WeatherService.call(coordinates[:lat], coordinates[:lng])
      (data[:hourly] | data[:daily]).find do |snapshot|
        snapshot[:dt] >= (Time.now.to_i + trip_time)
      end.slice(:temp, :weather)
    end
  end
end
