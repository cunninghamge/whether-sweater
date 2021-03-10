class ApplicationController < ActionController::API
  include Errorable

  rescue_from ArgumentError, with: :render_invalid_parameters
  rescue_from NoMethodError, with: :render_not_found
  rescue_from JSON::ParserError, with: :render_unavailable
end
