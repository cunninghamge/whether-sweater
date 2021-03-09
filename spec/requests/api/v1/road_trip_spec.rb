require 'rails_helper'

RSpec.describe 'road trip' do
  it 'gets road trip info' do
    VCR.use_cassette('denver_to_seattle') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      user = create(:user)
      trip_params = {
        origin: 'Denver,CO',
        destination: 'Seattle,WA',
        api_key: user.api_key
      }

      post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to be_a(Hash)
      check_hash_structure(data, :data, Hash)
      check_hash_structure(data[:data], :id, NilClass)
      check_hash_structure(data[:data], :type, String)
      expect(data[:data][:type]).to eq('roadtrip')
      check_hash_structure(data[:data], :attributes, Hash)
      check_hash_structure(data[:data][:attributes], :start_city, String)
      expect(data[:data][:attributes][:start_city]).to eq(trip_params[:origin])
      check_hash_structure(data[:data][:attributes], :end_city, String)
      expect(data[:data][:attributes][:end_city]).to eq(trip_params[:destination])
      check_hash_structure(data[:data][:attributes], :travel_time, String)
      expect(data[:data][:attributes][:travel_time]).to match(/\d+ hours, \d+ minutes/)
      check_hash_structure(data[:data][:attributes], :weather_at_eta, Hash)
      weather = data[:data][:attributes][:weather_at_eta]
      check_hash_structure(weather, :temperature, Numeric)
      check_hash_structure(weather, :conditions, String)
    end
  end

  it 'can handle road trips with travel time greater than 48 hours' do
    VCR.use_cassette('ak_to_panama') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      user = create(:user)
      trip_params = {
        origin: 'Prudhoe Bay, AK',
        destination: 'Panama City, Panama',
        api_key: user.api_key
      }

      post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      weather = data[:data][:attributes][:weather_at_eta]
      check_hash_structure(weather, :temperature, Numeric)
    end
  end

  it 'can handle impossible road trips' do
    VCR.use_cassette('impossible_trip') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      user = create(:user)
      trip_params = {
        origin: 'Denver, CO',
        destination: 'Berlin, DEU',
        api_key: user.api_key
      }

      post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:data][:attributes][:travel_time]).to eq('impossible')
      expect(data[:data][:attributes][:weather_at_eta]).to be_empty
    end
  end

  it 'returns an error if the origin is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      destination: 'Seattle,WA',
      api_key: user.api_key
    }

    post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the destination is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      origin: 'Denver,CO',
      api_key: user.api_key
    }

    post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an 401 if the api key is missing' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      origin: 'Denver,CO',
      destination: 'Seattle,WA'
    }

    post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

    expect(response.status).to eq(401)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an 401 if the api key is incorrect' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      origin: 'Denver,CO',
      destination: 'Seattle,WA',
      api_key: user.api_key[0..-2]
    }

    post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

    expect(response.status).to eq(401)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if the info is sent as query params' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      origin: 'Denver,CO',
      destination: 'Seattle,WA',
      api_key: user.api_key
    }

    post "/api/v1/road_trip?origin=#{trip_params[:origin]}&destination=#{trip_params[:destination]}&api_key=#{trip_params[:api_key]}", headers: headers

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error if an external API call is unsuccessful' do
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=#{ENV['LOCATION_API_KEY']}&to=Seattle,WA").to_return(status: 503)
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    user = create(:user)
    trip_params = {
      origin: 'Denver,CO',
      destination: 'Seattle,WA',
      api_key: user.api_key
    }

    post '/api/v1/road_trip', headers: headers, params: JSON.generate(trip_params)

    expect(response.status).to eq(503)
    errors = JSON.parse(response.body, symbolize_names: true)
    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end
end
