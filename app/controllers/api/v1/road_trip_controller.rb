class Api::V1::RoadTripController < ApplicationController
  before_action :reject_query_parameters, :validate_parameters

  def create
    road_trip = RoadTripFacade.road_trip(trip_params)
    render json: RoadTripSerializer.new(road_trip)
  end

  private

  def trip_params
    params.permit(:origin, :destination, :api_key)
  end

  def validate_parameters
    user = User.find_by(api_key: params[:api_key])
    if !user
      render_invalid_credentials('bad api_key')
    elsif !params[:origin]
      render_invalid_parameters('origin')
    elsif !params[:destination]
      render_invalid_parameters('destination')
    end
  end
end
