require 'rails_helper'

RSpec.describe CurrentWeatherService do
  it 'gets the current weather for a location' do
    destination = 'pueblo,co'

    forecast = CurrentWeatherService.call(destination)

    expect(forecast).to be_a(Hash)
    check_hash_structure(forecast, :weather, Array)
    expect(forecast[:weather][0]).to be_a(Hash)
    check_hash_structure(forecast[:weather][0], :description, String)
    check_hash_structure(forecast, :main, Hash)
    check_hash_structure(forecast[:main], :temp, Numeric)
  end
end
