require 'rails_helper'

RSpec.describe RestaurantService do
  it 'gets info for a restaurant by location and open_at' do
    destination = 'pueblo,co',
    food = 'hamburger',
    arrival_time = 8358
    restaurant = RestaurantService.call(destination, food, arrival_time)

    expect(restaurant).to be_a(Hash)
    check_hash_structure(restaurant, :name, String)
    check_hash_structure(restaurant, :location, Hash)
    check_hash_structure(restaurant[:location], :display_address, Array)
    all_strings = restaurant[:location][:display_address].all? do |part|
      part.class == String
    end
    expect(all_strings).to be true
  end
end
