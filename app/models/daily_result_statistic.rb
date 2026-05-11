class DailyResultStatistic < ApplicationRecord
  validates :date, presence: true
  validates :subject, presence: true
  validates :subject, uniqueness: { scope: :date }
  validates :daily_low,
            :daily_high,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }
  validates :result_count,
            numericality: { only_integer: true, greater_than: 0 }
  validate :daily_low_cannot_exceed_daily_high

  private

  def daily_low_cannot_exceed_daily_high
    return if daily_low.blank? || daily_high.blank?
    return if daily_low <= daily_high

    errors.add(:daily_low, "can't be greater than daily high")
  end
end
