module Errorable
  def render_invalid_parameters(parameter = 'location')
    error = "#{parameter} is a required parameter"
    render json: ErrorSerializer.serialize(error), status: :bad_request
  end

  def render_not_found
    render json: ErrorSerializer.serialize('location not found'), status: :not_found
  end

  def render_unavailable
    render json: ErrorSerializer.serialize('external API unavailable'), status: :service_unavailable
  end

  def render_invalid_credentials(error)
    render json: ErrorSerializer.serialize(error), status: :unauthorized
  end

  def reject_query_parameters
    return if request.query_parameters.blank?

    render_invalid_parameters(
      ['data must be sent in the body of the request',
       'do not send sensitive data as query parameters']
    )
  end
end
