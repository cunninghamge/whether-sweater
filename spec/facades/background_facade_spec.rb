require 'rails_helper'

RSpec.describe BackgroundFacade do
  it 'creates a background object' do
    VCR.use_cassette('portland') do
      background = BackgroundFacade.background('portland,or')

      expect(background).to be_a(Background)
    end
  end
end
