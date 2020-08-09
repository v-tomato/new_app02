class ApplicationController < ActionController::Base
    # CSRF保護をオンにする
    protect_from_forgery with: :exception
    
    include SessionsHelper
    
    
    private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい"
        redirect_to login_url
      end
    end
end
  