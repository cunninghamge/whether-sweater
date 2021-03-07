class LocationService
  class << self
    def call(location)
      response = conn.get do |req|
        req.params[:location] = location
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    private

    def conn
      @conn ||= Faraday.new('https://mapquestapi.com/geocoding/v1/address') do |req|
        req.params[:key] = ENV['LOCATION_API_KEY']
      end
    end
  end
end
