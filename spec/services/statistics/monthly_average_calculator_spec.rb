require 'rails_helper'

RSpec.describe Statistics::MonthlyAverageCalculator do
  describe '.call' do
    let(:date) { Date.current }

    before do
      5.times do |i|
        create(
          :daily_result_statistic,
          subject: 'Math',
          date: date - i.days,
          daily_low: 40,
          daily_high: 90,
          result_count: 50
        )
      end
    end

    it 'creates monthly average statistics' do
      expect {
        described_class.call(date)
      }.to change(MonthlyResultAverage, :count).by(1)

      result = MonthlyResultAverage.last

      expect(result.subject).to eq('Math')
      expect(result.average_daily_high).to eq(90)
      expect(result.average_daily_low).to eq(40)
      expect(result.total_result_count).to eq(250)
    end

    it 'uses at least five days before checking the 200 result threshold' do
      described_class.call(date)

      result = MonthlyResultAverage.find_by!(subject: 'Math')

      expect(result.total_result_count).to eq(250)
    end

    it 'keeps fetching older statistics when the latest five days are below 200' do
      create(
        :daily_result_statistic,
        subject: 'Science',
        date: date,
        daily_low: 40,
        daily_high: 80,
        result_count: 50
      )

      create(
        :daily_result_statistic,
        subject: 'Science',
        date: date - 1.day,
        daily_low: 50,
        daily_high: 90,
        result_count: 60
      )

      create(
        :daily_result_statistic,
        subject: 'Science',
        date: date - 2.days,
        daily_low: 45,
        daily_high: 85,
        result_count: 100
      )

      described_class.call(date)

      result =
        MonthlyResultAverage.find_by(subject: 'Science')

      expect(result.total_result_count).to eq(210)
    end

    it 'ignores daily statistics after the calculation date' do
      create(
        :daily_result_statistic,
        subject: 'History',
        date: date + 1.day,
        daily_low: 10,
        daily_high: 100,
        result_count: 500
      )

      expect {
        described_class.call(date)
      }.not_to change { MonthlyResultAverage.where(subject: 'History').count }
    end

    it 'updates the existing monthly average when run again' do
      described_class.call(date)

      DailyResultStatistic.where(subject: 'Math', date: date).update!(daily_high: 100)

      expect {
        described_class.call(date)
      }.not_to change(MonthlyResultAverage, :count)

      expect(MonthlyResultAverage.find_by!(subject: 'Math').average_daily_high).to eq(92)
    end

    it 'does not create averages when no daily statistics exist' do
      DailyResultStatistic.delete_all

      expect {
        described_class.call(date)
      }.not_to change(MonthlyResultAverage, :count)
    end
  end
end
