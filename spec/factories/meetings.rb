FactoryBot.define do
  factory :meeting do
    association :user
    
    trait :meeting_1 do
      title  {"test1"}
      content {"test1"}
      start_time {1.day.ago}
      user_id {1}
    end
    
    trait :meeting_2 do
      title {"test2"}
      content{"test2"}
      start_time {2.days.ago}
      user_id {1}
    end
    
    trait :meeting_3 do
      title  {"test3"}
      content {"test3"}
      start_time {3.days.ago}
      user_id {1}
    end
    
    trait :meeting_4 do
      title  {"test4"}
      content {"test4"}
      start_time {4.days.ago}
      user_id {1}
    end
    
  end
end
