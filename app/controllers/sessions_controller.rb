class SessionsController < ApplicationController
  skip_before_action :authenticate
  before_action :skip_authentication

  def create
    username = params[:username]
    password = params[:password]

    user = User.find_by(username: username)

    if user.nil? || ! user.authenticate(password)
      render :new, status: :unprocessable_entity
    else
      session[:user_id] = user.id
      redirect_to users_show_path(user.id), notice: "Welcome back!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to users_index_path, notice: "You were logged out"
  end
end
