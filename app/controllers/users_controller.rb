# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  def profile
    @user.update(views: @user.views + 1)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.attach_image(params[:user][:userimage])
      redirect_to root_path, notice: 'User created successfully.'
    else
      render :edit
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:role, :name, :email, :password, :userimage, :password_confirmation, :current_password,
                                 :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
