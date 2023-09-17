# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  def profile
    @user.update(views: @user.views + 1)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.attach_image(params[:user][:profile_image])
      redirect_to root_path, notice: 'User created successfully.'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :password, :password_confirmation, :current_password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
