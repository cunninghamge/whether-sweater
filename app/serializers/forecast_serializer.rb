class ForecastSerializer
  include FastJsonapi::ObjectSerializer
  set_id { nil }
  attributes :current_weather, :hourly_weather, :daily_weather
end
