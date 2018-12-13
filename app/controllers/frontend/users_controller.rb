class Frontend::UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def id_user
    # datos hardcodeados hasta tener data de users
    @user = General::User.second
    data = []
    data << {
      id: @user.id,
      name: @user.name,
      last_name: @user.last_name,
      email: @user.email,
      image: @ip.to_s + Rails.application.routes.url_helpers.rails_blob_path(@user.image, only_path: true)
    }
    respond_to do |format|
      format.json { render json: data[0] }
      format.js
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        format.json
      else
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end    
  end

  private

  def set_user
    @user = General::User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :name, image: [])
  end
end