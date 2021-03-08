class Api::V1::MunchiesController < ApplicationController
  def show
    munchie = MunchiesFacade.munchie(munchie_params)
    render json: MunchieSerializer.new(munchie)
  end

  private

  def munchie_params
    params.permit(:start, :destination, :food)
  end
end
