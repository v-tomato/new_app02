require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  
  let(:user) { create(:user) }
  
  describe "GET /login" do
    # 有効でないログインの時、フラッシュメッセージが表示される
    it "has a danger flash message because of invalid login information" do
      get login_path
      post login_path, params: {
        session: {
          email: "",
          password: ""
        }
      }
      # expect(flash[:danger]).to be_turthy
      expect(flash[:danger]).to be_present
    end
    
    # 有効のログインの時、フラッシュメッセージが表示されない
    it "has no danger flash message because of invalid login information" do
      get login_path
      post login_path, params: {
        session: {
          email: user.email,
          password: user.password
        }
      }
      expect(flash[:danger]).not_to be_present
    end
  end
end


