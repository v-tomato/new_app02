class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # 次回：ここに、ユーザーページへリダイレクトさせる記述を加える
    else
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません'
      render 'new'
    end
  end
  
  def destroy
  end
end
