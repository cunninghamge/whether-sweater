class RouteService
  class << self
    def call(start, destination)
      response = conn.get do |req|
        req.params[:from] = start
        req.params[:to] = destination
      end
      body = JSON.parse(response.body, symbolize_names: true)
      body[:route].slice(:formattedTime, :realTime)
    end

    private

    def conn
      @conn ||= Faraday.new('http://www.mapquestapi.com/directions/v2/route') do |req|
        req.params[:key] = ENV['LOCATION_API_KEY']
      end
    end
  end
end
