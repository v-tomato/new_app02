require 'rails_helper'

RSpec.describe "UsersDestroy", type: :request do
  
  let(:user){ create(:user)}
  let(:other_user) { create(:other_user) }
  
  describe "User-destroy" do
    
    # ログインユーザーの削除
    it "is valid by logged in user delete user-information" do
      log_in_as(user)
      get user_path(user)
      expect{ delete user_path(1) }.to change(User, :count).by(-1)
      follow_redirect!
      expect(request.fullpath).to eq '/'
      expect(flash[:success]).to be_truthy
    end
    
    # ログインしていないユーザーが削除しようとしてもログイン画面に遷移する
    it "is invalid user-information delete by other user " do
      log_in_as(user)
      get user_path(user)
      delete logout_path
      follow_redirect!
      get user_path(1)
      follow_redirect!
      expect(request.fullpath).to eq "/login"
      expect(flash[:danger]).to be_truthy
    end
      
  end
  
end