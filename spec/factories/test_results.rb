FactoryBot.define do
  factory :test_result do
    student_name { Faker::Name.name }
    subject { 'Math' }
    marks { rand(50..100) }
    submitted_at { Time.current }
  end
end