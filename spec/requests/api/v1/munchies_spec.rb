require 'rails_helper'

RSpec.describe 'munchies request' do
  it 'returns a restaurant in a destination that will be open at the time of arrival' do
    start_location = 'denver,co'
    end_location = 'pueblo,co'
    food = 'hamburger'

    get "/api/v1/munchies?start=#{start_location}&destination=#{end_location},co&food=#{food}"

    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)
    expect(data).to be_a(Hash)
    check_hash_structure(data, :data, Hash)
    check_hash_structure(data[:data], :id, NilClass)
    check_hash_structure(data[:data], :type, String)
    expect(data[:data][:type]).to eq('munchie')
    check_hash_structure(data[:data], :attributes, Hash)

    attributes = data[:data][:attributes]
    check_hash_structure(attributes, :destination_city, String)
    check_hash_structure(attributes, :travel_time, String)
    check_hash_structure(attributes, :forecast, Hash)
    check_hash_structure(attributes[:forecast], :summary, String)
    check_hash_structure(attributes[:forecast], :temperature, Numeric)
    check_hash_structure(attributes, :restaurant, Hash)
    check_hash_structure(attributes[:restaurant], :name, String)
    check_hash_structure(attributes[:restaurant], :address, String)
  end
end
