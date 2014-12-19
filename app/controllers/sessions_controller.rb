class SessionsController < ApplicationController
 
 def new
 end

  def create
  user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
       session[:user_id] = user.id
       user.increment_login
       if params[:remember_me]
         cookies.permanent[:auth_token] = user.auth_token
       else
         cookies[:auth_token] = user.auth_token
       end
        redirect_to user_path(user.id), :notice =>"Welcome back, #{user.email}"
      else
       flash.now.alert = "Invalid Email or password"
        render "sessions/new"
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:auth_token)
    reset_session
    redirect_to log_in_path, notice: "Signed out!"
  end




 end



