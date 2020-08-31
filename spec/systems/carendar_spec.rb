require 'rails_helper'

RSpec.describe "Carendar", type: :system do 
  
  before do
    user = FactoryBot.create(:user)
    meeting = FactoryBot.create(:meeting, user: user)
    
    def schedule_valid_information
      fill_in "タイトル", with: "TEST1"
      fill_in "開始時刻", with: 1.day.ago
      fill_in "内容", with: "test1"
      find(".form-submit").click
    end
    
    def schedule_invalid_information
      fill_in "タイトル", with: ""
      fill_in "開始時刻", with: nil
      fill_in "内容", with: "test1"
      find(".form-submit").click 
    end
    
    
    describe "Create-controller" do
      # 有効なスケジュール入力の場合の画面遷移
      it "is valid create" do
        visit new_user_meeting(@user)
        schedule_valid_information
        expect { schedule_valid_information }.to change(Meeting, :count).by(1)
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_selector ".calendar-1"
        expect(flash[:success]).to be_truthy
      end
    
      # 無効なスケジュール入力の場合の画面遷移
      it "is invalid create schedule because of invalid information" do
        visit new_user_meeting(@user)
        schedule_invalid_information  
        expect { schedule_invalid_information }.not_to change(Meeting, :count)
        expect(current_path).to eq new_user_meeting_path(1)
        expect(page).to have_selector ".signup-container"
        expect(flash[:danger]).to be_truthy
      end
    end
    
    describe "Edit-controller" do
      # 有効なスケジュール編集の場合の画面遷移
      it "is valid edit" do
        visit edit_user_meeting_path(@meeting)
        schedule_valid_information
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_selector ".calendar-1"
        expect(flash[:success]).to be_truthy
      end
      
      # 無効なスケジュール編集の場合の画面遷移
      it "is invalid edit because of invalid information" do
        visit edit_user_meeting_path(@meeting)
        schedule_invalid_information
        expect(current_path).to eq edit_user_meeting_path(1)
        expect(page).to have_selector ".signup-container"
        expect(flash[:danger]).to be_truthy
      end
    end
    
    describe "Destroy-controller" do
      # 有効なスケジュール削除の場合の画面遷移
      it "is valid destroy" do
        visit user_meeting_path(@meeting)
        clicK_link "削除"
        expect(current_path).to eq user_meetings_path(1)
        expect(page).to have_selector ".calendar-1"
        expect(flash[:success]).to be_truthy
      end
    end
    
    describe "Show-controller" do
      it "goes to show-views" do
        visit user_meetings_path(@user)
        expect(current_path).to eq user_meetings_path(1)
        click_link "@meeting.title"
        expect(current_path).to user_meeting_path(@user, @meeting)
        expect(page).to have_selector show-meetings-text
      end
    end
  end
end