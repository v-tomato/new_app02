class UsersController < ApplicationController
  
  # Userモデルを作る受け皿を作る
  def new
    @user = User.new
  end

  # フォームの情報からUserモデルを作る
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Schedule Application へようこそ！"
      redirect_to @user
    else
      render 'new'
    end
  end

  # フォームから送信されたパラメーターからユーザーを特定する
  def show
    @user = User.find(params[:id])
  end
  
  def update
  end
  
  def delete
  end
  
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
