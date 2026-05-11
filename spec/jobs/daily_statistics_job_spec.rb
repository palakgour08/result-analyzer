require 'rails_helper'

RSpec.describe DailyStatisticsJob, type: :job do
  describe '#perform' do
    let(:date) { Date.current }

    it 'calls the daily calculator service' do
      expect(Statistics::DailyCalculator)
        .to receive(:call)
        .with(date)

      described_class.perform_now(date)
    end
  end
end