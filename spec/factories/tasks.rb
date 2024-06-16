FactoryBot.define do
  factory :task do
    title { 'Test Task' }
    state { 'Backlog' }
    deadline { 2.days.from_now }
    association :user
  end
end