class Api::V1::SessionsController < ApplicationController
  before_action :reject_query_parameters
  
  def create
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      render json: UserSerializer.new(user)
    else
      render_invalid_credentials
    end
  end
end
