require 'rails_helper'

RSpec.describe BackgroundService do
  it 'can get an image' do
    VCR.use_cassette('portland') do
      data = BackgroundService.call('portland,or')

      expect(data).to be_a(Hash)
      check_hash_structure(data, :results, Array)
      expect(data[:results].size).to eq(1)
      result = data[:results][0]
      expect(result).to be_a(Hash)
      check_hash_structure(result, :urls, Hash)
      check_hash_structure(result[:urls], :raw, String)
      check_hash_structure(result, :user, Hash)
      check_hash_structure(result[:user], :name, String)
      check_hash_structure(result[:user], :links, Hash)
      check_hash_structure(result[:user][:links], :html, String)
    end
  end

  it 'provides source info' do
    info = BackgroundService.source_info

    expect(info).to eq({
      source: 'Unsplash',
      source_url: "https://unsplash.com/?utm_source=weather-sweater&utm_medium=referral",
      append_to_user_url: '?utm_source=weather-sweater&utm_medium=referral'
    })
  end

  it 'can get an image of a different city' do
    VCR.use_cassette('new_orleans') do
      data = BackgroundService.call('new%20orleans,la')

      expect(data).to be_a(Hash)
      check_hash_structure(data, :results, Array)
      expect(data[:results].size).to eq(1)
    end
  end

  it 'returns empty results if an image can\'t be found' do
    VCR.use_cassette('not_a_city_background') do
      data = BackgroundService.call('NOTAREALPLACE')

      expect(data).to be_a(Hash)
      check_hash_structure(data, :results, Array)
      expect(data[:results]).to be_empty
    end
  end
end
