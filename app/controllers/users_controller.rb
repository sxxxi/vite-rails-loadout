class UsersController < ApplicationController
  skip_before_action :authenticate, only: [ :new, :create ]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # 1. User is logged out => redirect to user profile
      # 2. User is logged in => go back to users list
      if session[:user_id].blank?
        session[:user_id] = @user.id
        redirect_to users_show_path(session[:user_id])
      else
        redirect_to users_index_path, notice: "User \"#{[ @user.first_name, @user.last_name ].join(" ")}\" created"
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    user_id = params[:id]
    @user = User.find_by id: user_id

    if @user.nil?
      render file: "public/404.html", status: :not_found
    end
  end

  def destroy
    user_id = params[:id]
    @user = User.delete(user_id)

    if session[:user_id] == user_id
      session[:user_id] = nil
    end

    flash[:message] = "The user has been deleted"
    redirect_to users_index_path
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation)
    end
end
