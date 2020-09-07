class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # rememberのチェックボックス onかoffか
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # redirect_back_or user
        redirect_back_or user_meetings_path(current_user)
      else
        flash[:danger] = "メールを確認して認証を済ませてください"
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません'
      render 'new'
    end
  end
 
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end


