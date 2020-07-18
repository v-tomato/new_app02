module SessionsHelper
  
  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  
  
  # 現在ログイン中のユーザーを返す
  def current_user
    # session[:user_id]が存在すれば、一時セッションからユーザーを取得
    if (user_id =session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
      # @current_user = @current_user || User.find_by(id: session[:user_id])
    # cookies[:user_id]が存在すれば、永続セッションからユーザーを取得
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    
  end
  
# ユーザーがログイン中の状態とは「sessionにユーザーidが存在している=current_user」と言うこと、
# つまり「current_userがnilではない」という状態
# チェックするには否定演算子,'!'を使用
  def logged_in?
    !current_user.nil?
  end
  
#   sessionを削除することでログアウト
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil  
  end
  
  
  # ユーザーのセッションを永続的にする・作ったトークン、暗号化したトークン、暗号化したIDの３つを保存する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
