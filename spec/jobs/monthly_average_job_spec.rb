require 'rails_helper'

RSpec.describe MonthlyAverageJob, type: :job do
  describe '#perform' do
    let(:date) { Date.new(2026, 5, 18) }

    context 'when eligible' do
      it 'calls monthly calculator' do
        allow(DateRules::MonthlyAverageEligibility)
          .to receive(:eligible?)
          .and_return(true)

        expect(Statistics::MonthlyAverageCalculator)
          .to receive(:call)
          .with(date)

        described_class.perform_now(date)
      end
    end

    context 'when not eligible' do
      it 'does not call monthly calculator' do
        allow(DateRules::MonthlyAverageEligibility)
          .to receive(:eligible?)
          .and_return(false)

        expect(Statistics::MonthlyAverageCalculator)
          .not_to receive(:call)

        described_class.perform_now(date)
      end
    end
  end
end