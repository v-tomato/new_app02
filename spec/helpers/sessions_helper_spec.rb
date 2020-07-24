require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  
  let(:user) { create(:user) }
  
  describe "current_user" do
    
    # 永続セッションでユーザーを特定できるか
    it "returns right user when session is nil" do
      remember (user)
      expect(current_user).to eq user
      expect(is_logged_in?).to be_truthy
    end
    
    # 不適格なトークンをremember_digestに代入した時、current_userはnilになるか
    it "current_user returns nil when remember digest is wrong" do
      remember (user)
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
    
  end
  
end
