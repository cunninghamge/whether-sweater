require 'rails_helper'

RSpec.describe CityService do
  describe '.location' do
    it 'can get the coordinates of a city' do
      city = 'rutland,vt'
      lat = 43.610633
      lng = -72.972688
      data = CityService.location(city)

      expect(data).to be_a(Hash)
      check_hash_structure(data, :results, Array)
      expect(data[:results][0]).to be_a(Hash)
      check_hash_structure(data[:results][0], :locations, Array)
      location = data[:results][0][:locations][0]
      expect(location).to be_a(Hash)
      check_hash_structure(location, :latLng, Hash)
      check_hash_structure(location[:lagLng], :lat, Float)
      expect(location[:latLng][:lat]).to eq(lat)
      check_hash_structure(location[:lagLng], :lng, Float)
      expect(location[:latLng][:lng]).to eq(lng)
    end

    it 'can get the coordinates of a different city' do
      city = 'bend,or'
      lat = 44.058088
      lng = -121.31515
      data = CityService.location(city)

      expect(data[:results][0][:locations][0][:latLng][:lat]).to eq(lat)
      expect(data[:results][0][:locations][0][:latLng][:lng]).to eq(lng)
    end

    it 'can get the coordinates of an international city' do
      city = 'berlin,de'
      lat = 52.517037
      lng = 13.38886
      data = CityService.location(city)

      expect(data[:results][0][:locations][0][:latLng][:lat]).to eq(lat)
      expect(data[:results][0][:locations][0][:latLng][:lng]).to eq(lng)
    end

    it 'gets default coordinates if it can\'t find a place' do
      not_a_city = 'NOTAREALPLACE'
      lat = 39.390897
      lng = -99.066067
      data = CityService.location(not_a_city)

      expect(data[:results][0][:locations][0][:latLng][:lat]).to eq(lat)
      expect(data[:results][0][:locations][0][:latLng][:lng]).to eq(lng)

      also_not_a_city = 'alsonotarealplace'
      data = CityService.location(also_not_a_city)

      expect(data[:results][0][:locations][0][:latLng][:lat]).to eq(lat)
      expect(data[:results][0][:locations][0][:latLng][:lng]).to eq(lng)
    end
  end
end
