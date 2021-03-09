class TripService
  class << self
    def call(params)
      response = conn.get do |req|
        req.params[:from] = params[:origin]
        req.params[:to] = params[:destination]
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    private

    def conn
      @conn ||= Faraday.new('http://www.mapquestapi.com/directions/v2/route') do |req|
        req.params[:key] = ENV['LOCATION_API_KEY']
      end
    end
  end
end
