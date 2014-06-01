class UserMailer < ActionMailer::Base
  include Resque::Mailer

  default from: "no-reply@pp2code.com"

  def welcome_email(user_id)
    @user = User.find user_id
    mail(to: @user.email, subject: 'Welcome to pp2code')
  end
end
