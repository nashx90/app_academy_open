class UsersController < ApplicationController
  before_action
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    if params[:username]
      users = User.where('username LIKE ?', "%#{params[:username]}%")
    else
      users = User.all
    end
    render json: users
  end

  def show
    user = User.find(params[:id])
    if user
      render json: user
    else
      render json: user.error.full_messages, status: :unprocessable_entity
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

  def handle_record_not_found
    render plain: "User not found", status: :unprocessable_entity
  end

end