# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    # adds debugging via byebug gem
    # debugger
  end

  def create
    @user = User.new(user_params) # NOT FINAL
    if @user.save
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end
end
