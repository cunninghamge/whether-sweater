class CurrentWeatherService
  class << self
    def call(destination)
      response = conn.get do |req|
        req.params[:q] = destination.split(',').first
      end
      body = JSON.parse(response.body, symbolize_names: true)
      body.slice(:weather, :main)
    end

    private

    def conn
      @conn ||= Faraday.new('https://api.openweathermap.org/data/2.5/weather') do |req|
        req.params[:units] = :imperial
        req.params[:appid] = ENV['WEATHER_API_KEY']
      end
    end
  end
end
