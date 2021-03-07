class Api::V1::BackgroundController < ApplicationController
  def show
    background = BackgroundFacade.background(params[:location])
    render json: BackgroundSerializer.new(background)
  end
end
