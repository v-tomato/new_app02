require 'rails_helper'

RSpec.describe "Users-login", type: :system do
    
　let(:user) { create(:user) }
　
　describe "Login" do
    
    context "有効でないログイン" do
      it "is invalid because it has no name" do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_on 'ログイン'
        expect(current_path).to eq signup_path
        expect(page).to have_selector '#error_explanation'
      end
    
    # フラッシュメッセージが他のページに遷移後、消えている
      it "deletes flash messages when users input invalid information then other links" do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        #   find(".form-submit").click
        click_on 'ログイン'
        expect(page).to eq login_path
        expect(page).to have_selector 'signup-container'
        expect(page).to have_selector '.alert-danger'
        visit root_path
        expect(page).not_to have_selector '.alert-danger'
　　  end
    end 

    context "有効なログイン" do
      it "is valid because it fulfils condition of input" do
         visit login_path
         fill_in 'メールアドレス', with: 'user.email'
         fill_in 'パスワード', with: 'password'
         click_on 'ログイン'
         expect(current_path).to eq user_path(1)
         expect(page).to have_selector '.show-container'
      end
     
      it "ログインした後、ログアウトボタン有、ログインボタン無" do
        visit login_path
        fill_in 'メールアドレス', with: 'user.email'
        fill_in 'パスワード', with: 'password'
        click_on 'ログイン'
        expect(current_path).to eq user_path(1)
        expect(page).to have_selector '.show-container'
        expect(page).to have_link 'Logout'
        expect(page).not_to have_link 'Login'
      end
      
    end
  
  describe "Logout" do
    it "ログアウトした後、ログインボタン有、ログアウトボタン無"
      visit login_path
      fill_in 'メールアドレス', with: 'user.email'
      fill_in 'パスワード', with: 'password'
      click_on 'ログイン'
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.show-container'
      expect(page).to have_link 'Logout'
      expect(page).not_to have_link 'Login'
      click_on 'ログアウト'
      expect(current_path).to eq root_path
      expect(page).to have_selector '.container'
      expect(page).not_to have_link 'Logout'
      expect(page).to have_link 'Login'
    end
  end
end