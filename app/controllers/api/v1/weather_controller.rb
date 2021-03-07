class Api::V1::WeatherController < ApplicationController
  def show
    if params[:location].present?
      forecast = WeatherFacade.forecast(params[:location])
      render json: ForecastSerializer.new(forecast)
    else
      render_invalid_parameters
    end
  end
end
