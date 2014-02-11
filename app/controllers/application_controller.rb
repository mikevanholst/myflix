class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def require_user
    #add only path true to secure against phishing railscast 358
    redirect_to sign_in_path, only_path: true unless current_user
  end

  def require_admin
    unless current_user.admin
      flash[:error] = "You are not authorized for that action."
      redirect_to home_path
    end
  end

  def current_user
   @current_user = @current_user || User.find(session[:user_id]) if session[:user_id]
  end
end
