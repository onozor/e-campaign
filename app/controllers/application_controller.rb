class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :capture_referal #:capture_signed_in
  helper_method :current_user, :capture_signed_in


  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end


  def authenticate_user!
    if not session[:user_id]
      flash[:notice] = "Please Log in"
      redirect_to  :controller => "sessions", :action => 'new'
    end
  end

  def authorise_user
    @user = User.find(params[:id])
     unless @user == current_user
        redirect_to root_url, notice: "Access Denied!"
       end
  end


  def capture_signed_in
    if current_user && controller_path == new_user_path || new_session_path
      redirect_to root_url, notice: "You have already sign in"
    end
  end


  private
  def capture_referal
    session[:referral] = params[:referral] if params[:referral]
  end
end

