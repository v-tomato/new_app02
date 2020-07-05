module SessionsHelper
  
  # 渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  
  
  # 現在ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    #   @current_user = @current_user || User.find_by(id: session[:user_id])
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
    session.delete(:user_id)
    @current_user = nil  
  end

end
