class UserMailer < ActionMailer::Base
  default from: "alexonozor@gmail.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def registration_confirmation(user, login_url)
    @login_url = login_url
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Welcome to APP")
  end
end
