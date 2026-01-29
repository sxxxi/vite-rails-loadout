class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path
    else
      render "/auth/register", status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
