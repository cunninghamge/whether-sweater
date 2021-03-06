class WeatherService
  def self.call(lat, lon)
    response = conn.get do |req|
      req.params[:lat] = lat
      req.params[:lon] = lon
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.conn
    @conn ||= Faraday.new('https://api.openweathermap.org/data/2.5/onecall') do |req|
      req.params[:appid] = ENV['WEATHER_API_KEY']
      req.params[:exclude] = 'minutely,alerts'
      req.params[:units] = 'imperial'
    end
  end
end
