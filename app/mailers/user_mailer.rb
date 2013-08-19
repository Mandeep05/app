class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def activation(user)
    @user = user
    @activation_link = activate_url(@user.signup_token)
    mail :to => user.email, :subject => "Account Activation"
  end
end
