class BackgroundService
  class << self
    def call(location)
      response = conn.get do |req|
        req.params[:query] = location
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    def source_info
      {
        source: 'Unsplash',
        source_url: "https://unsplash.com/?utm_source=weather-sweater&utm_medium=referral",
        append_to_user_url: '?utm_source=weather-sweater&utm_medium=referral'
      }
    end

    private

    def conn
      @conn ||= Faraday.new('https://api.unsplash.com/search/photos') do |req|
        req.params[:per_page] = 1
        req.params[:client_id] = ENV['BACKGROUND_API_KEY']
      end
    end
  end
end
