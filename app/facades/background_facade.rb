class BackgroundFacade
  def self.background(location)
    data = BackgroundService.call(location)
    source_info = BackgroundService.source_info
    Background.new(data[:results][0], location, source_info)
  end
end
