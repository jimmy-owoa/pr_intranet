# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def azure_oauth2
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
