class Api::V1::RoadTripController < ApplicationController
  before_action :reject_query_parameters

  def create
    user = User.find_by(api_key: params[:api_key])
    if params[:origin] && params[:destination] && user
      road_trip = RoadTripFacade.road_trip(trip_params)
      render json: RoadTripSerializer.new(road_trip)
    elsif !user
      render_invalid_credentials
    else
      render_invalid_parameters
    end
  end

  private

  def trip_params
    params.permit(:origin, :destination)
  end
end
