require 'rails_helper'

RSpec.describe "Users-login", type: :system do


  let(:user) { create(:user) }
  
  def signup_invalid_information
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    # ログイン
    find(".form-submit").click
  end
  
  def signup_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find(".form-submit").click
    check 'session_remember_me' if [:remember_me] == 1
  end
  
  describe "Login" do
    
    context "有効でないログイン" do
      it "is invalid because it has no name" do
        visit login_path
        signup_invalid_information
        expect(current_path).to eq login_path
        # expect(page).to have_selector '#error_explanation'
        expect(page).to have_selector '.alert-danger'
      end
    
    # フラッシュメッセージが他のページに遷移後、消えている
      it "deletes flash messages when users input invalid information then other links" do
        visit login_path
        signup_invalid_information
        expect(current_path).to eq login_path
        expect(page).to have_selector '.signup-container'
        expect(page).to have_selector '.alert-danger'
        visit root_path
        expect(page).not_to have_selector '.alert-danger'
      end
    end 
  end
    context "有効なログイン" do
      it "is valid because it fulfils condition of input" do
        visit login_path
        signup_valid_information
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_selector '.calendar-1'
      end
     
      it "ログインした後、ログアウトボタン有、ログインボタン無" do
        visit login_path
        signup_valid_information
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_selector '.calendar-1'
        expect(page).to have_link 'Logout'
        expect(page).not_to have_link 'Login'
      end
    end
  
  describe "Logout" do
    it "ログアウトした後、ログインボタン有、ログアウトボタン無" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      expect(page).to have_selector '.calendar-1'
      expect(page).to have_link 'Logout'
      expect(page).not_to have_link 'Login'
      click_link 'Logout'
      expect(current_path).to eq root_path
      expect(page).to have_selector '.container'
      expect(page).not_to have_link 'Logout'
      expect(page).to have_link 'Login'
    end
  end
end