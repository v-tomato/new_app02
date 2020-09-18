require 'rails_helper'

RSpec.describe "User", type: :system do 
    
  let(:user) { create(:user) }
  
  def signup_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find(".form-submit").click
    check 'session_remember_me' if [:remember_me] == 1
  end
    
  it "is valid user-destroy" do
    visit login_path
    signup_valid_information
    expect(current_path).to eq user_meetings_path(1)
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