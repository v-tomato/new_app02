class UserMailer < ApplicationMailer

 def account_activation(user)
    @user = user
    mail to: user.email, subject: "【重要】Schedule Appよりアカウント有効化のためのメールを届けました"
  end


  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【重要】Schedule Appよりパスワード再設定のためのメールを届けました"
  end
  
end
