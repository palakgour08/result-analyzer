require 'rails_helper'

RSpec.describe DailyResultStatistic, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:subject) }

    it do
      should validate_numericality_of(:daily_low)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it do
      should validate_numericality_of(:daily_high)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it do
      should validate_numericality_of(:result_count)
        .only_integer
        .is_greater_than(0)
    end

    it 'requires the low mark to be less than or equal to the high mark' do
      statistic = build(:daily_result_statistic, daily_low: 90, daily_high: 80)

      expect(statistic).not_to be_valid
      expect(statistic.errors[:daily_low]).to include("can't be greater than daily high")
    end

    it 'allows one statistic per subject per date' do
      create(:daily_result_statistic, date: Date.new(2026, 5, 10), subject: 'Math')
      duplicate = build(:daily_result_statistic, date: Date.new(2026, 5, 10), subject: 'Math')

      expect(duplicate).not_to be_valid
    end
  end
end
