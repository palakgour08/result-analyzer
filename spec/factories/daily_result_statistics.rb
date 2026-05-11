FactoryBot.define do
  factory :daily_result_statistic do
    date { Date.current }
    subject { 'Math' }
    daily_low { 45 }
    daily_high { 95 }
    result_count { 20 }
  end
end