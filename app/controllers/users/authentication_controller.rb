class Users::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, raise: false
  # raise false se puso por que se llama más de una vez (es por rails 5, stackoverflow)

  def authenticate

    command = AuthenticateUserEmployee.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

end
