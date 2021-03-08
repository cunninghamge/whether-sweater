require 'rails_helper'

RSpec.describe Munchie do
  it 'exists and has attributes' do
    destination = 'pueblo,co'
    travel_time = '01:44:22'
    forecast = {
      weather: [
        {
          id: 804,
          main: "Clouds",
          description: "overcast clouds",
          icon: "04d"
        }
      ],
      main:  {
        temp: 82.67,
        feels_like: 93.06,
        temp_min: 82.67,
        temp_max: 82.67,
        pressure: 1011,
        humidity: 81,
        sea_level: 1011,
        grnd_level: 986
      }
    }
    restaurant = {
      name: "Bingo Burger",
      location: {
        address1: "101 Central Plz",
        address2: "",
        address3: "",
        city: "Pueblo",
        zip_code: "81003",
        country: "US",
        state: "CO",
        display_address: ["101 Central Plz", "Pueblo, CO 81003"]}}
    munchie = Munchie.new(destination, travel_time, forecast, restaurant)

    expect(munchie).to be_a(Munchie)
    expect(munchie).to have_attributes(
      destination_city: 'Pueblo, CO',
      travel_time: '1 hour, 44 minutes',
      forecast: {
        summary: forecast[:weather][0][:description],
        temperature: forecast[:main][:temp]
      },
      restaurant: {
        name: restaurant[:name],
        address: restaurant[:location][:display_address]*', '
      }
    )
  end
end
