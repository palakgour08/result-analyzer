require 'rails_helper'

RSpec.describe Statistics::DailyCalculator do
  describe '.call' do
    let(:date) { Date.current }

    before do
      create(:test_result,
             subject: 'Math',
             marks: 50,
             submitted_at: date.beginning_of_day)

      create(:test_result,
             subject: 'Math',
             marks: 90,
             submitted_at: date.beginning_of_day)

      create(:test_result,
             subject: 'Science',
             marks: 70,
             submitted_at: date.beginning_of_day)

      create(:test_result,
             subject: 'Math',
             marks: 100,
             submitted_at: date.tomorrow.beginning_of_day)
    end

    it 'creates daily statistics for each subject' do
      expect {
        described_class.call(date)
      }.to change(DailyResultStatistic, :count).by(2)

      math_stat = DailyResultStatistic.find_by(subject: 'Math')

      expect(math_stat.daily_low).to eq(50)
      expect(math_stat.daily_high).to eq(90)
      expect(math_stat.result_count).to eq(2)
    end

    it 'updates existing statistics when run again' do
      described_class.call(date)

      create(:test_result, subject: 'Math', marks: 20, submitted_at: date.noon)

      expect {
        described_class.call(date)
      }.not_to change(DailyResultStatistic, :count)

      math_stat = DailyResultStatistic.find_by!(date: date, subject: 'Math')
      expect(math_stat.daily_low).to eq(20)
      expect(math_stat.daily_high).to eq(90)
      expect(math_stat.result_count).to eq(3)
    end

    it 'does not create statistics when no test results exist' do
      TestResult.delete_all

      expect {
        described_class.call(date)
      }.not_to change(DailyResultStatistic, :count)
    end
  end
end
