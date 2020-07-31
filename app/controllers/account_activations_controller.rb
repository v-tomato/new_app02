class AccountActivationsController < ApplicationController
    
  # def edit
  #   user = User.find_by(email: params[:email])
  #   # 既に有効になっているユーザーを誤って再度有効化しないため
  #   if user && !user.activated? && user.authenticated?(:activation, params[:id])
  #     user.activate
  #     log_in user
  #     flash[:success] = "Schedule App へようこそ！"
  #     redirect_to user
  #   else
  #     flash[:danger] = "認証に失敗しました"
  #     redirect_to root_url
  #   end
  # end
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Lantern Lanternへようこそ！"
      redirect_to user
    else
      flash[:danger] = "アクティベーションに失敗しました"
      redirect_to root_url
    end
  end
  
end
