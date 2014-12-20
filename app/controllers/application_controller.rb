class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :capture_referal#:capture_signed_in
  before_action :check_account_confirmation
  helper_method :current_user, :capture_signed_in


  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]

  end


  def check_account_confirmation
    if current_user && current_user.registration_complete == false
      session[:user_id] = nil
      flash[:notice] = 'This account has not being confirmed '
      redirect_to :controller => "sessions", :action => 'new'
    end
  end

  def authenticate_user!
    if not session[:user_id]
      flash[:notice] = "You must log in before continuing"
      redirect_to  :controller => "sessions", :action => 'new'
    end
  end









  def capture_referal
    session[:referral] = params[:referral] if params[:referral]
  end
end

