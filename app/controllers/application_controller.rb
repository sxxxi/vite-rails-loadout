class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern if Rails.env.production?
  before_action :authenticate

  private
    def authenticate
      if session[:user_id].blank?
        redirect_to sessions_new_path
      end
    end

    def skip_authentication
      if !session[:user_id].blank? && request.path == sessions_new_path || request.path == users_new_path
        redirect_to users_index_path
      end
    end
end
