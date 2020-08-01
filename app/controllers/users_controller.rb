class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]
  
  # Userモデルを作る受け皿を作る
  def new
    @user = User.new
  end

  # フォームの情報からUserモデルを作る
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "認証用メールを送信しました。登録時のメールアドレスから認証を済ませてください"
      redirect_to @user
    else
      render 'new'
    end
  end

  # フォームから送信されたパラメーターからユーザーを特定する
  def show
    @user = User.find(params[:id])
  end
  
  # プロフィールの編集
  def edit
    @user = User.find(params[:id])
  end
  
  # PATCH
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報の変更が完了しました"
      redirect_to @user
    else
      flash.now[:danger] = "アカウント情報の変更が失敗しました"
      render "edit"
    end
  end
  
  def delete
  end
  
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeアクション
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
