require 'rails_helper'

RSpec.describe 'forecast request' do
  it 'gets weather for a specified location' do
    VCR.use_cassette('rutland') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      get '/api/v1/forecast?location=rutland,vt', headers: headers

      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to be_a(Hash)
      check_hash_structure(data, :data, Hash)
      expect(data[:data].keys).to match_array(%i[id type attributes])
      check_hash_structure(data[:data], :id, NilClass)
      check_hash_structure(data[:data], :type, String)
      expect(data[:data][:type]).to eq('forecast')
      check_hash_structure(data[:data], :attributes, Hash)
      expect(data[:data][:attributes].keys).to match_array(%i[current_weather daily_weather hourly_weather])

      attributes = data[:data][:attributes]

      check_hash_structure(attributes, :current_weather, Hash)
      expect(attributes[:current_weather].keys).to match_array(%i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions icon])
      check_hash_structure(attributes[:current_weather], :datetime, String)
      expect(attributes[:current_weather][:datetime]).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
      check_hash_structure(attributes[:current_weather], :sunrise, String)
      expect(attributes[:current_weather][:sunrise]).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
      check_hash_structure(attributes[:current_weather], :sunset, String)
      expect(attributes[:current_weather][:sunset]).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
      check_hash_structure(attributes[:current_weather], :temperature, Float)
      check_hash_structure(attributes[:current_weather], :feels_like, Float)
      check_hash_structure(attributes[:current_weather], :humidity, Numeric)
      check_hash_structure(attributes[:current_weather], :uvi, Numeric)
      check_hash_structure(attributes[:current_weather], :visibility, Numeric)
      check_hash_structure(attributes[:current_weather], :conditions, String)
      check_hash_structure(attributes[:current_weather], :icon, String)

      check_hash_structure(attributes, :daily_weather, Array)
      expect(attributes[:daily_weather].size).to eq(5)
      day0 = attributes[:daily_weather][0]
      expect(day0).to be_a(Hash)
      expect(day0.keys).to match_array(%i[date sunrise sunset max_temp min_temp conditions icon])
      check_hash_structure(day0, :date, String)
      expect(day0[:date]).to match(/^\d{4}-\d{2}-\d{2}$/)
      check_hash_structure(day0, :sunrise, String)
      expect(day0[:sunrise]).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
      check_hash_structure(day0, :sunset, String)
      expect(day0[:sunset]).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
      check_hash_structure(day0, :max_temp, Float)
      check_hash_structure(day0, :min_temp, Float)
      check_hash_structure(day0, :conditions, String)
      check_hash_structure(day0, :icon, String)

      check_hash_structure(attributes, :hourly_weather, Array)
      expect(attributes[:hourly_weather].size).to eq(8)
      hour0 = attributes[:hourly_weather][0]
      expect(hour0).to be_a(Hash)
      expect(hour0.keys).to match_array(%i[time temperature conditions icon])
      check_hash_structure(hour0, :time, String)
      expect(hour0[:time]).to match(/^\d{2}:\d{2}:\d{2}$/)
      check_hash_structure(hour0, :temperature, Numeric)
      check_hash_structure(hour0, :conditions, String)
      check_hash_structure(hour0, :icon, String)
    end
  end

  it 'returns an error with a message if a location param is not included' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/forecast', headers: headers

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error with a message if the location is blank' do
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/forecast?location', headers: headers

    expect(response.status).to eq(400)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error with a message if the location can\'t be found' do
    VCR.use_cassette('not_a_city') do
      headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
      get '/api/v1/forecast?location=NOTAREALPLACE', headers: headers

      expect(response.status).to eq(404)
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors).to be_a(Hash)
      expect(errors.keys).to match_array(%i[errors])
      check_hash_structure(errors, :errors, Array)
      expect(errors[:errors][0]).to be_a(String)
    end
  end

  it 'returns an error with a message if the external maps API call is unsuccessful' do
    stub_request(:get, 'map')
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/forecast?location=rutland,vt', headers: headers

    expect(response.status).to eq(503)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end

  it 'returns an error with a message if the external maps weather call is unsuccessful' do
    stub_request(:get, 'weather')
    headers = {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}
    get '/api/v1/forecast?location=rutland,vt', headers: headers

    expect(response.status).to eq(503)
    errors = JSON.parse(response.body, symbolize_names: true)

    expect(errors).to be_a(Hash)
    expect(errors.keys).to match_array(%i[errors])
    check_hash_structure(errors, :errors, Array)
    expect(errors[:errors][0]).to be_a(String)
  end
end
