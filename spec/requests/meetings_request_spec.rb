require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  
  before do
    user = FactoryBot.create(:user)
    meeting = FactoryBot.create(:meeting, user: user)

    def post_valid_information
       post user_meetings_path(@meeting), params: { meeting: { title: "aaa", start_time: 1.day.ago, content: "aaa" } }
    end

    def post_invalid_information
      post user_meetings_path(@meeting), params: { meeting: { title: nil, start_time: nil, content: "aaa", user_id: user.id } }
    end

    def patch_valid_information
      patch user_meetings_path(@meeting.id), params: { meeting: { title: "aaa", start_time: 1.day.ago, content: "aaa" } }
    end

    def patch_invalid_information
      patch user_meetings_path(@meeting.id), params: { micropost: { title: nil, start_time: nil, content: "aaa" } }
    end
  
  
    describe "POST /users/:id/meetings" do
      # ログイン後の投稿が有効か
      it "is valid by logged in user " do
        log_in_as(user)
        get user_path(user)
        expect(request.fullpath).to eq '/users/1'
        expect{ post_valid_information}.to change(Meeting, :count).by(1)
        follow_riderct!
        expect(request.fullpath).to eq " /users/1/meetings"
      end
      
      # ログインしていないユーザの予定投稿が無効か
      it "does not create a meeting when not logged in" do
        expect{ post_valid_information }.not_to change(Meeting, :count)
        follow_redirect!
        expect(request.fullpath).to eq "/login"
      end
    
      # フォームが全て空欄のユーザ投稿が無効か
      it "does not create a meeting when the form has no information" do
        log_in_as(user)
        get user_path(user)
        expect{ post_invalid_information }.not_to change(Meeting, :count)
      end
      
     
    end
    
    describe "DELETE / /users/:user_id/meetings/:id" do
      #  ログイン後の投稿削除が有効
      it "is valid by logged in user" do
        log_in_as(user)
        get user_path(user)
        expect{ post_valid_information }.to change(Meeting, :count).by(1)
        follow_riderct!
        expect{ delete meetings_path(1) }.to change(Meeting, :count).by(-1)
        follow_riderct!
        expect(request.fullpath).to eq '/users/1'
        expect(flash[:success]).to be_truthy
      end
      
      # ログインしていないユーザの投稿削除が無効
      it "is invalid destroy by not logged in user" do
        delete meetings_path(1)
        follow_redirect!
        expect(request.fullpath).to eq "/login"
      end
      
      # 他ユーザの投稿削除が無効か
      it "is invalid destroy by other user logged in" do
        log_in_as(user)
        get user_path(user)
        delete logout_path
        log_in_as(other_user)
        get user_path(other_user)
        expect(request.fullpath).to eq "users/2"
        post_valid_information
        expect{ delete meetings_path(1) }.not_to change(Meeting, :count)
        expect{ delete meetings_path(2) }.to change(Meeting, :count).by(-1)
      end
      
    end
    
    
    describe "GET / /users/:user_id/meetings/:id/edit" do
      # ログイン後の投稿編集は有効か
      it "is valid by logged in user" do
        log_in_as(user)
        get user_path(user)
        post_valid_information
        follow_redirect!
        get edit_meeting_path(1)
        expect(request.fullpath).to eq "/users/1/meetings/1/edit"
        patch_valid_information
        follow_redirect!
        expect(request.fullpath).to eq "/users/1/meetings"
      end
      
      # ログインしていないユーザの投稿編集が無効か
      it "is invalid edit by not logged in user" do
        log_in_as(user)
        get user_path(user)
        post_valid_information
        follow_redirect!
        delete logout_path
        follow_redirect!
        get edit_meeting_path(1)
        follow_redirect!
        expect(request.fullpath).to eq "/login"
      end
      
      # 他ユーザの投稿編集が無効か
      it "is invalid edit by other user " do
        log_in_as(user)
        get user_path(user)
        post_valid_information
        follow_redirect!
        delete logout_path
        follow_redirect!
        log_in_as(other_user)
        get edit_meeting_path(1)
        expect(request.fullpath).to eq "/"
      end
      
      # フォームが全て空欄の投稿編集が無効か
      it "is invalid edit when all forms are empty" do
        log_in_as(user)
        get user_path(user)
        post_invalid_information
        follow_redirect!
        get edit_meeting_path(1)
        follow_redirect!
        expect(request.fullpath).to eq "/users/1/meetings/1/edit"
        patch_invalid_information
        follow_redirect!
        expect(request.fullpath).to eq "users/1/meetings/new"
      end
    end
    
    
    
 
  end
end
