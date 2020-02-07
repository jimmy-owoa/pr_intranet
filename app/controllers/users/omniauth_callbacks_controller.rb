class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def azure_oauth2
    @user = General::User.from_omniauth(request.env["omniauth.auth"])
    if @user.present?
      sign_in_and_redirect(@user)
    else
      flash[:alert] = "Debe ingresar a una cuenta válida para continuar."
      redirect_to user_azure_oauth2_omniauth_authorize_path
    end
  end

  def passthru
    super
  end

  def failure
    super
  end

  protected

  def after_omniauth_failure_path_for(scope)
    super(scope)
  end
end
