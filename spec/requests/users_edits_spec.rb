require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  
  let(:user){ create(:user)}
  let(:other_user) { create(:other_user) }
  
  def patch_users_edit_invalid_information
    patch user_path(user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end
  
   def patch_users_edit_valid_information
    patch user_path(user), params: {
      user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }
  end

  describe "GET /users/:id/edit" do
    context "invalid" do
      it "is invalid edit because of invalid information" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy
        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'
        patch_users_edit_invalid_information
        expect(flash[:danger]).to be_truthy
        expect(request.fullpath).to eq '/users/1'
      end
      
      # 不正なユーザーにプロフィール編集前にログインを要求
      it "is invalid edit because of having log in" do
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
      
      # 不正なユーザーが間違ったログインにより、ログインできない
      it "is invalid log in bacause of invalid log in as wrong user" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
      
      # 不正なユーザーがアカウントの編集をできない様にする
      it "does not redirect update bacause of invalid log in as wrong user" do
        log_in_as(other_user)
        get edit_user_path(user)
        patch_users_edit_valid_information
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
    
    context "valid" do
      it "is valid edit because of invalid information" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy
        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'
        patch_users_edit_valid_information
        expect(flash[:success]).to be_truthy
        expect(request.fullpath).to eq '/users/1'
      end
    end
  end
  
end