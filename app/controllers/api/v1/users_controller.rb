class Api::V1::UsersController < Api::ApplicationController

  def show
    render json: UserSerializer.new(@current_api_user).to_json
  end
  s
end