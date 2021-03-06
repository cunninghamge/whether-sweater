class Api::V1::WeatherController < ApplicationController
  def show
    forecast = WeatherFacade.forecast(params[:location])
    # require "pry"; binding.pry
    render json: ForecastSerializer.new(forecast)
  end
end
