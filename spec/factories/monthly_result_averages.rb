FactoryBot.define do
  factory :monthly_result_average do
    calculated_on { Date.current }
    subject { 'Math' }

    average_daily_high { 90.5 }
    average_daily_low { 45.2 }

    total_result_count { 250 }
  end
end