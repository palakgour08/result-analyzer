class MonthlyResultAverage < ApplicationRecord
  validates :calculated_on, presence: true
  validates :subject, presence: true
  validates :subject, uniqueness: { scope: :calculated_on }
  validates :average_daily_high,
            :average_daily_low,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }
  validates :total_result_count,
            numericality: { only_integer: true, greater_than: 0 }
end
