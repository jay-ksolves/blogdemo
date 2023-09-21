# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  def profile
    @user.update(views: @user.views + 1)
  end

  # def create
  #   @user = User.new(user_params)

  #   if @user.save
  #     # Associate the user with the selected subscription plan
  #     case params[:user][:subscription_plan]
  #     when 'basic_plan'
  #       @user.subscription = Subscription.find_by(name: 'Basic Plan')
  #     when 'professional_plan'
  #       @user.subscription = Subscription.find_by(name: 'Professional Plan')
  #     when 'elite_plan'
  #       @user.subscription = Subscription.find_by(name: 'Elite Plan')
  #     end

  #     # Assign the appropriate role based on the subscription plan
  #     if @user.subscription.name == 'Basic Plan'
  #       @user.add_role :basic
  #     elsif @user.subscription.name == 'Professional Plan'
  #       @user.add_role :professional
  #     elsif @user.subscription.name == 'Elite Plan'
  #       @user.add_role :elite
  #     end
  #     @user.attach_image(params[:user][:userimage])
  #     redirect_to root_path, notice: 'User created successfully.'
  #   else
  #     render :new
  #   end
  # end

  # def create
  #   @user = User.new(user_params)

  #   if @user.save
  #     # Associate the user with the selected subscription plan
  #     subscription = Subscription.find_by(name: params[:user][:subscription_plan])
  #     if subscription.nil?
  #       subscription = Subscription.find_by(name: 'Free Plan')
  #     end
  #     @user.subscription = subscription

  #     # Assign the appropriate role based on the subscription plan
  #     case subscription.name
  #     when 'Basic Plan'
  #       @user.add_role :basic
  #     when 'Professional Plan'
  #       @user.add_role :professional
  #     when 'Elite Plan'
  #       @user.add_role :elite
  #     else
  #       @user.add_role :free
  #     end

  #     @user.attach_image(params[:user][:userimage])
  #     redirect_to root_path, notice: 'User created successfully.'
  #   else
  #     render :new
  #   end
  # end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.attach_image(params[:user][:userimage])
      redirect_to root_path, notice: 'User created successfully.'
    else
      render :new
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
