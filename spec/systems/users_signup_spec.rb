require 'rails_helper'

RSpec.describe "Users-sigup", type: :system do
    
    let(:user) { create(:user) }
    
    it "is invalid because it has no name" do
      visit login_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
    #   find(".form-submit").click
      click_on 'ログイン'
      expect(page).to eq login_path
      expect(page).to have_selector 'signup-container'
      expect(page).to have_selector '.alert-danger'
    end
    
    # フラッシュメッセージが他のページに遷移後、消えている
    it "deletes flash messages when users input invalid information then other links" do
      visit signup_path
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
    
    
    it "is valid because it fulfils condition of input" do
        visit signup_path
        fill_in 'メールアドレス', with: 'user.email'
        fill_in 'パスワード', with: 'password'
        #   find(".form-submit").click
        click_on 'ログイン'
        expect(current_path).to eq user_path(1)
        expect(page).not_to have_selector '.show-container'
    end
  end 
end
