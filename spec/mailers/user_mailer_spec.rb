require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
  # let(:user){ (:create) }
  let(:user) { FactoryBot.create(:user) }
  
  describe "account_activation" do
     
    let(:mail) { UserMailer.account_activation(user) }
    
    # メール送信のテスト
    it "renders the headers" do
      expect(mail.subject).to eq("【重要】Schedule Appよりアカウント有効化のためのメールを届けました")
      expect(mail.to).to eq(["michael@example.com"])
      # expect(mail.to).to eq( sequence(:email) { |n| "tester#{n}@example.com" } )
      expect(mail.from).to eq(["noreply@example.com"])
    end
    
    # メールプレビューのテスト
    it "renders the body" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
  
end
