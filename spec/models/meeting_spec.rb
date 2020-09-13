require 'rails_helper'

RSpec.describe Meeting, type: :model do
    
  let(:user) { create(:user) }
  let(:meeting) { user.meetings.build(title: "test1", start_time: 1.day.ago, content: "testA", user_id: user.id) }
    
  describe "Meeting_model" do
    # モデルが正しく生成されているか
    it "is valid model" do
      expect(meeting).to be_valid
    end
    
    # title,start_time値が空の場合（user_idを除く）、Meetingは存在しないか
    it "is invalid because of it has not title" do
      meeting.update(title: " ", start_time: 1.day.ago, content: " ", user_id: user.id)
      expect(meeting).to be_invalid
    end
    
    it "is invalid because of it has not start_time" do
      meeting.update(title: "test1", start_time: nil, content: " ", user_id: user.id)
      expect(meeting).to be_invalid
    end
    
    it "is invalid because of it has not title and start_time" do
      meeting.update(title: " ", start_time: nil, content: "", user_id: user.id)
      expect(meeting).to be_invalid
    end
  end
  
  # user_idが存在しないMeetingは存在しないか
  describe "user_id" do
    it "is not to be present"  do
      meeting.user_id = nil
      expect(meeting).to be_invalid
    end
  end
  
  
  # 画像のテスト
  describe "picture" do
    it "is valid if all columns are nil except picture" do
      meeting.update_attributes(title: " ", start_time: 1.day.ago, content: " ", user_id: user.id)
      expect(meeting).to be_invalid
      meeting.picture.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'test.jpg')), filename: 'test.jpg', content_type: 'image/jpg')
      expect(meeting).to be_invalid
    end
    
    it "is valid if content is empty "do
      meeting.update_attributes(title: "test1", start_time: 1.day.ago, content: " ", user_id: user.id)
      expect(meeting).to be_valid
      meeting.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test.jpg')), filename: 'test.jpg', content_type: 'image/jpg')
      expect(meeting).to be_valid
    end
    
    it "should not be over than 5MB" do
      meeting.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test_5mb.jpg')), filename: 'test_5mb.jpg', content_type: 'image/jpg')
      expect(meeting).to be_invalid
    end

    it "should be only images file" do
      meeting.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test.pdf')), filename: 'test.pdf', content_type: 'application/pdf')
      expect(meeting).to be_invalid
    end
  end
end