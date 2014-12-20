class UserMailer < ActionMailer::Base
  default from: "alexonozor@gmail.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.email}>", :subject => "Email Confirmation")
  end
end
