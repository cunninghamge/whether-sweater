require 'rails_helper'

RSpec.describe 'background request' do
  it 'retrieves a background image for a location' do
    VCR.use_cassette('portland') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      get '/api/v1/background?location=portland,or', headers: headers

      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to be_a(Hash)
      check_hash_structure(data, :data, Hash)
      expect(data[:data].keys).to match_array(%i[id type attributes])
      check_hash_structure(data[:data], :id, NilClass)
      check_hash_structure(data[:data], :type, String)
      expect(data[:data][:type]).to eq('image')
      check_hash_structure(data[:data], :attributes, Hash)
      expect(data[:data][:attributes].keys).to match_array(%i[location image_url credit])

      attributes = data[:data][:attributes]

      check_hash_structure(attributes, :location, String)
      check_hash_structure(attributes, :image_url, String)
      check_hash_structure(attributes, :credit, Hash)
      check_hash_structure(attributes[:credit], :source, String)
      expect(attributes[:credit][:source]).to eq('Unsplash')
      check_hash_structure(attributes[:credit], :source_url, String)
      unsplash_url = "https://unsplash.com/?utm_source=weather-sweater&utm_medium=referral"
      expect(attributes[:credit][:source_url]).to eq(unsplash_url)
      check_hash_structure(attributes[:credit], :photographer, String)
      check_hash_structure(attributes[:credit], :photographer_url, String)
      expect(attributes[:credit][:photographer_url]).to match(/^https:\/\/unsplash.com\/@/)
      expect(attributes[:credit][:photographer_url]).to match(/utm_source=weather-sweater&utm_medium=referral$/)
    end
  end

  it 'returns an error with a message if a location param is not included' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/background', headers: headers

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error with a message if the location is blank' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/background?location', headers: headers

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error with a message if the location can\'t be found' do
    VCR.use_cassette('not_a_city_background') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      get '/api/v1/background?location=NOTAREALPLACE', headers: headers

      expect(response.status).to eq(404)
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end
  end

  it 'returns an error with a message if the external maps API call is unsuccessful' do
    stub_request(:get, "https://api.unsplash.com/search/photos?client_id=#{ENV['BACKGROUND_API_KEY']}&per_page=1&query=portland,or").to_return(status: 503)
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/background?location=portland,or', headers: headers

    expect(response.status).to eq(503)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end
end
