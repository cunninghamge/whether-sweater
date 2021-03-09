require 'rails_helper'

RSpec.describe WeatherSnapshot do
  let(:data) { { weather: [
                  {
                    id: 804,
                    main: "Clouds",
                    description: "overcast clouds",
                    icon: "04d"
                  }
                ] } }
  let(:offset) { -18000 }

  it 'exists and has attributes' do
    snapshot = WeatherSnapshot.new(data, offset)

    expect(snapshot).to be_a(WeatherSnapshot)
    expect(snapshot).to have_attributes(
      conditions: data[:weather][0][:description],
      icon: data[:weather][0][:icon]
    )
  end

  describe 'instance methods' do
    it '#local_time' do
      dt = Time.now.to_i
      snapshot = WeatherSnapshot.new(data, offset)

      expect(snapshot.local_time(dt, offset)).to match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} -\d{4}$/)
    end
  end
end
