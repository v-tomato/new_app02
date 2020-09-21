require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do 
 
 let(:user) { create(:user) }
 
 def signup_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find(".form-submit").click
    check 'session_remember_me' if [:remember_me] == 1
  end
  
  describe "home layout" do
     it "contains root link" do
      visit root_path
      expect(page).to have_link "Home", href: root_path
     end
     
      it "contains login link" do
       visit login_path
       expect(page).to have_link 'Login', href: login_path
      end
     
     it "contains about link" do
       visit about_path
       expect(page).to have_link 'About', href: about_path
     end
     
     it "contains contact link" do
        visit contact_path
        expect(page).to have_link "Contact", href: contact_path
     end
     
     it "contains questions link" do
        visit questions_path
        expect(page).to have_link "Questions", href: questions_path
        click_on "Questions"
        visit questions_path
        expect(page).to have_link "こちら", href: signup_path
        expect(page).to have_css ".masthead-heading" ".text-uppercase"
     end
   end
   
   
  # ログイン後のレイアウト
   describe "home layout when User logged in" do
     it "contains root link" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      visit root_path
      expect(page).to have_link "Home", href: root_path
     end
     
     it "contains logout link" do
      visit login_path
      signup_valid_information
      expect(current_path).to eq user_meetings_path(1)
      visit login_path
      expect(page).to have_link 'Logout', href: logout_path
     end
     
     it "contains about link" do
       visit login_path
       signup_valid_information
       expect(current_path).to eq user_meetings_path(1)
       expect(page).to have_link 'About', href: about_path
     end
     
     it "contains contact link" do
        visit login_path
        signup_valid_information
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_link "Contact", href: contact_path
     end
     
     it "contains questions link" do
        visit login_path
        signup_valid_information
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_link "Questions", href: questions_path
        click_on "Questions"
        visit questions_path
        expect(page).to have_link "こちら", href: signup_path
        expect(page).to have_css ".masthead-heading" ".text-uppercase"
     end
     
     it "contains profile link" do
       visit login_path
       signup_valid_information
       expect(current_path).to eq user_meetings_path(1)
       expect(page).to have_link "Profile", href: user_path(1)
     end
     
     it "contains calendar link" do
       visit login_path
       signup_valid_information
       expect(current_path).to eq user_meetings_path(1)
       expect(page).to have_link "Calendar", href: user_meetings_path(1)
     end
   end
  
end