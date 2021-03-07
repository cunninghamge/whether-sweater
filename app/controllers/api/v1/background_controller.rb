class Api::V1::BackgroundController < ApplicationController
  def show
    if params[:location].present?
      background = BackgroundFacade.background(params[:location])
      render json: BackgroundSerializer.new(background)
    else
      render_invalid_parameters
    end
  end
end
