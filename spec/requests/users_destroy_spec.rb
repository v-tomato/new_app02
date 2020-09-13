require 'rails_helper'

RSpec.describe "UsersDestroy", type: :request do
  
  let(:user){ create(:user)}
  let(:other_user) { create(:other_user) }
  
  describe "User-destroy" do


      # it "as an admin user" do
      #   let(:admin){ create(:user)}
      #   before do
      #     sign_in admin
      #     visit users_path
      #   end

      #   it { should have_link('delete', href: user_path(User.first)) }
      #   it "should be able to delete another user" do
      #     expect { click_link('delete') }.to change(User, :count).by(-1)
      #   end
      #   it { should_not have_link('delete', href: user_path(admin)) }
      # end 
      
    # get signup_path
    #     expect{
    #       post users_path,
    #       params:{
    #         user:{ name:  "Example User",
    #               email: "user@example.com",
    #               password: "password",
    #               password_confirmation: "password" 
    #         }
    #       }
    #     }.to change(User, :count).by(1)
    expect(click_link "退会(ユーザー削除)").to change(User, :count).by(1)
      
  end
  
end