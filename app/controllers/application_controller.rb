class ApplicationController < ActionController::API
  rescue_from ArgumentError, with: :render_invalid_parameters
  rescue_from NoMethodError, with: :render_not_found
  rescue_from JSON::ParserError, with: :render_unavailable

  def render_invalid_parameters(error = 'location is required')
    render json: ErrorSerializer.serialize(error), status: :bad_request
  end

  def render_not_found
    render json: ErrorSerializer.serialize('location not found'), status: :not_found
  end

  def render_unavailable
    render json: ErrorSerializer.serialize('external API unavailable'), status: :service_unavailable
  end

  def render_invalid_credentials
    render json: ErrorSerializer.serialize('Invalid email or password'), status: :unauthorized
  end

  def reject_query_parameters
    return if request.query_parameters.blank?

    render_invalid_parameters('user information must not be sent as query parameters')
  end
end
