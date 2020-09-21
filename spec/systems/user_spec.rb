require 'rails_helper'

RSpec.describe "User", type: :system do 
    
  let(:user) { create(:user) }
  
  def signup_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find(".form-submit").click
    check 'session_remember_me' if [:remember_me] == 1
  end
  
  def valid_edit_information
    fill_in '名前', with: user.name
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード(再入力)', with: 'password'
    find(".form-submit").click
  end
  
  def invalid_edit_information
    fill_in '名前', with: user.name
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード(再入力)', with: ' '
    find(".form-submit").click
  end
  
  
  describe "User-Destroy" do
    it "is valid user-destroy" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      click_link "Profile"
      visit user_path(1)
      expect(page).to have_css ".show-meetings-text"
      click_on "退会(ユーザー削除)"
      expect {
        expect(page.driver.browser.switch_to.alert.text).to eq "削除しますか？"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ユーザーを削除しました'       
      }.to change{ User.count }.by(-1)
      expect(current_path).to eq root_path
      expect(page).to have_selector ".alert-success"
    end
  end
  
  describe "User-Show" do
    it "should be displayed User-Show-page" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      click_link "Profile"
      visit user_path(1)
      expect(current_path).to eq user_path(1)
      expect(page).to have_css ".show-meetings-text"
    end
  end
  
  describe "User-Edit" do
    it "is valid edit" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      click_link "Profile"
      visit user_path(1)
      expect(page).to have_content "ユーザー名"
      expect(page).to have_content "メールアドレス"
      click_link "ユーザー編集"
      visit edit_user_path(1)
      expect(page).to have_content "プロフィール"
      expect(page).to have_content "情報変更"
      valid_edit_information
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector ".alert-success", text: "アカウント情報の変更が完了しました"
      expect(page).to have_content "ユーザー名"
      expect(page).to have_content "メールアドレス"
    end
    
    it "is invalid edit" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      click_link "Profile"
      visit user_path(1)
      expect(page).to have_content "ユーザー名"
      expect(page).to have_content "メールアドレス"
      click_link "ユーザー編集"
      visit edit_user_path(1)
      expect(page).to have_content "プロフィール"
      expect(page).to have_content "情報変更"
      invalid_edit_information
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector ".alert-danger", text: "アカウント情報の変更が失敗しました"
      expect(page).to have_content "プロフィール"
      expect(page).to have_content "情報変更"
    end
  
  end
  
end