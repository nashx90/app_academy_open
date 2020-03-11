# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :ensure_logged_in, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if @user
      log_in_user!(@user)
      flash[:notice] = 'Succesfully logged in!'
      redirect_to root_path
    else
      flash[:notice] = 'User not found'
      redirect_to new_session_url
    end
  end

  def destroy
    log_out!
    flash[:notice] = 'Successfully logged out!'
    redirect_to new_session_url
  end
end
