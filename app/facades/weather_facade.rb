class WeatherFacade
  def self.forecast(location)
    location_data = LocationService.call(location)
    coordinates = location_data[:results][0][:locations][0][:latLng]
    weather_data = WeatherService.call(coordinates[:lat], coordinates[:lng])
    Forecast.new(weather_data)
  end
end
