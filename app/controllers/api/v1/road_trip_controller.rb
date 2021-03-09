class Api::V1::RoadTripController < ApplicationController
  def create
    road_trip = RoadTripFacade.road_trip(trip_params)
    render json: RoadTripSerializer.new(road_trip)
  end

  private

  def trip_params
    params.permit(:origin, :destination)
  end
end
