class ApplicationController < ActionController::API
  rescue_from ArgumentError, with: :render_invalid_parameters
  rescue_from NoMethodError, with: :render_not_found
  rescue_from JSON::ParserError, with: :render_unavailable

  def render_invalid_parameters
    render json: ErrorSerializer.serialize('location is required'), status: :bad_request
  end

  def render_not_found
    render json: ErrorSerializer.serialize('location not found'), status: :not_found
  end

  def render_unavailable
    render json: ErrorSerializer.serialize('external API unavailable'), status: :service_unavailable
  end
end
