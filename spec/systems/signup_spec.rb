require 'rails_helper'

RSpec.describe "Signup", type: :system do 
    
  def signup_invalid_information
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'user@invalid'
    fill_in 'パスワード(6文字以上)', with: 'foo'
    fill_in 'パスワード（再入力）', with: 'bar'
    find(".form-submit").click
  end
    
  def signup_valid_information
    fill_in '名前', with: 'Example User'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード(6文字以上)', with: 'password'
    fill_in 'パスワード（再入力）', with: 'password'
    find(".form-submit").click
  end
  
  it "is invalid signup because of invalid information" do
    visit signup_path
    signup_invalid_information
    expect(current_path).to eq signup_path
    expect(page).to have_selector '.alert-danger'
  end
  
  it "is valid signup" do
    visit signup_path
    expect { signup_valid_information }.to change(User, :count).by(1)
    expect(current_path).to eq user_path(1)
    expect(page).not_to have_selector '.alert-danger'
  end
end