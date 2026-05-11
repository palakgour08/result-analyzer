require 'rails_helper'

RSpec.describe MonthlyResultAverage, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:calculated_on) }
    it { should validate_presence_of(:subject) }

    it do
      should validate_numericality_of(:average_daily_high)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it do
      should validate_numericality_of(:average_daily_low)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it do
      should validate_numericality_of(:total_result_count)
        .only_integer
        .is_greater_than(0)
    end

    it 'allows one monthly average per subject per calculation date' do
      create(:monthly_result_average, calculated_on: Date.new(2026, 5, 18), subject: 'Math')
      duplicate = build(:monthly_result_average, calculated_on: Date.new(2026, 5, 18), subject: 'Math')

      expect(duplicate).not_to be_valid
    end
  end
end
