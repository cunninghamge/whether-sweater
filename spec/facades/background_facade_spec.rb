require 'rails_helper'

RSpec.describe BackgroundFacade do
  it 'creates a background object' do
    VCR.use_cassette('portland') do
      expect(BackgroundService).to receive(:call)
      .with('portland,or')
      .and_call_original
      expect(BackgroundService).to receive(:source_info).and_call_original

      background = BackgroundFacade.background('portland,or')

      expect(background).to be_a(Background)
    end
  end
end
