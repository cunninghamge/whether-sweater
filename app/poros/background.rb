class Background
  attr_reader :location,
              :image_url

  def initialize(data, location, source_info)
    @location = location
    @image_url = data[:urls][:raw]
    @user_info = data[:user]
    @source_info = source_info
  end

  def credit
    {
      source: @source_info[:source],
      source_url: @source_info[:source_url],
      photographer: @user_info[:name],
      photographer_url: "#{@user_info[:links][:html]}#{@source_info[:append_to_user_url]}"
    }
  end
end
