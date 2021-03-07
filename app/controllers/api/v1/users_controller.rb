class Api::V1::UsersController < ApplicationController
  before_action :reject_query_parameters

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.serialize(user.errors.full_messages), status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
