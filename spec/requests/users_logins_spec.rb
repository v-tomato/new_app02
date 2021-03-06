require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper
  
  let(:user) { create(:user) }
  let(:no_activation_user) { create(:no_activation_user) }
  
  # 無効なログイン 
  def post_invalid_information
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
  end
  
  # ログインのメソッド
  def post_valid_information(login_user, remember_me = 0)
    post login_path, params: {
      session: {
        email: login_user.email,
        password: login_user.password,
        remember_me: remember_me
      }
    }
  end
  
  describe "GET /login" do
    # 修正
    # 有効でないログインの時、フラッシュメッセージが表示される
    it "has a danger flash message because of invalid login information" do
      get login_path
      post_invalid_information
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
      expect(request.fullpath).to eq '/login'
    end
    
    # 修正
    # アクティベーションできていないとログインに失敗する
    it "fails because they have not activated account" do
      get login_path
      post_valid_information(no_activation_user)
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
    
    # 修正
    # 有効のログインの時、フラッシュメッセージが表示されない
    it "has no danger flash message because of invalid login information" do
      get login_path
      post_valid_information(user)
      expect(flash[:danger]).to be_falsey
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      # expect(request.fullpath).to eq '/users/1'
      expect(request.fullpath).to eq '/users/1/meetings'
    end
  end
  
  
  # 二度ログアウトできても、それでもエラーは起こらない
  it "does not log out twice" do
    get login_path
    post_valid_information(user)
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    # expect(request.fullpath).to eq '/users/1'
    expect(request.fullpath).to eq '/users/1/meetings'
    # ログアウト
    delete logout_path
    expect(is_logged_in?).to be_falsey
    # follow_redirect! = POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    expect(request.fullpath).to eq '/'
    # ログアウト
    delete logout_path
    follow_redirect!
    expect(request.fullpath).to eq '/'
  end
  
  # チェックボックスがオンの時 トークンが作られているか
  it "succeeds remember_token because of check remember_me" do
    get login_path
    post_valid_information(user, remember_me = 1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_empty
  end

  # チェックボックスがオフの時、トークンが作られていないか
  it "has no remember_token when user doesn't fill in checkbox" do
    get login_path
    post_valid_information(user, remember_me = 0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
  end
  
  # チェックボックスがオンの時 ログアウト後のログインでトークンが残っていないか
  it "has no remember_token after logged out and login when user fill in checkbox" do
    get login_path
    post_valid_information(user, remember_me = 1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_empty
    delete logout_path
    expect(is_logged_in?).to be_falsey
    expect(cookies[:remember_token]).to be_empty
  end
  
end
