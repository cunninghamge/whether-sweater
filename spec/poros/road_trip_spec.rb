require 'rails_helper'

RSpec.describe RoadTrip do
  it 'exists and has attributes' do
    params = {
      origin: 'Denver,CO',
      destination: 'Seattle,WA'
    }
    travel_time = "18:24:27"
    forecast = {
      :temp=>51.08,
      :weather=>[
        {
          :id=>500,
          :main=>"Rain",
          :description=>"light rain",
          :icon=>"10d"
          }
        ]
    }
    road_trip = RoadTrip.new(params, travel_time, forecast)

    expect(road_trip).to be_a(RoadTrip)
    expect(road_trip).to have_attributes(
      start_city: params[:origin],
      end_city: params[:destination],
      travel_time: "18 hours, 24 minutes",
      weather_at_eta: {
        temperature: forecast[:temp],
        conditions: forecast[:weather][0][:description]
      }
    )
  end
end
