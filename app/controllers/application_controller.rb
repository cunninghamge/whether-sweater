class ApplicationController < ActionController::API
  rescue_from ArgumentError, with: :render_invalid_parameters
  rescue_from NoMethodError, with: :render_not_found

  def render_invalid_parameters
    render json: ErrorSerializer.serialize('location is required'), status: :bad_request
  end

  def render_not_found
    render json: ErrorSerializer.serialize('location not found'), status: :not_found
  end
end
