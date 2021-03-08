class RestaurantService
  class << self
    def call(destination, food, travel_time)
      response = conn.get do |req|
        req.params[:term] = food
        req.params[:location] = destination
        req.params[:open_at] = Time.now.to_i + travel_time
      end
      body = JSON.parse(response.body, symbolize_names: true)
      body[:businesses][0].slice(:name, :location)
    end

    private

    def conn
      @conn ||= Faraday.new('https://api.yelp.com/v3/businesses/search') do |req|
        req.params[:categories] = :restaurant
        req.params[:limit] = 1
        req.headers[:Authorization] = "Bearer #{ENV['YELP_API_KEY']}"
      end
    end
  end
end
