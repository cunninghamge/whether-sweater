require 'rails_helper'

RSpec.describe RouteService do
  it 'gets travel time between a start and destination' do
    start = 'denver,co'
    destination = 'seattle,wa'

    route = RouteService.call(start, destination)

    expect(route).to be_a(Hash)
    check_hash_structure(route, :realTime, Integer)
    check_hash_structure(route, :formattedTime, String)
  end
end
