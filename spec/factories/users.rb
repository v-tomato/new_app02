FactoryBot.define do
  factory :user do
    name { "Michael Example" }
    # email { "michael@example.com" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
  
  factory :other_user, class: User do
    name { "Sterling Archer" }
    # email { "duchess@example.gov" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
