FactoryBot.define do
  factory :task do
    title {"wasshoi"}
    content {"hogehoge"}
    status {1}
    user
  end
end
