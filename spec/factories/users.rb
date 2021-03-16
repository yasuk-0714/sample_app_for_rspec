FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}wasshoi@example.com" }
    password {"password"}
    password_confirmation {"password"}
  end
end
