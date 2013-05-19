class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      sign_in @user
      flash[:success] = 'Account successfully created!'
    else
      render :new
    end
  end

end
