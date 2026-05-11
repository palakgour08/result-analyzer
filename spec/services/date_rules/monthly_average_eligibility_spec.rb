require 'rails_helper'

RSpec.describe DateRules::MonthlyAverageEligibility do
  describe '.eligible?' do
    it 'returns true for monday of week containing third wednesday' do
      date = Date.new(2026, 5, 18)

      expect(described_class.eligible?(date)).to be true
    end

    it 'returns false for other dates' do
      date = Date.new(2026, 5, 19)

      expect(described_class.eligible?(date)).to be false
    end

    it 'handles months where the third wednesday is early in the month' do
      eligible_date = Date.new(2026, 4, 13)

      expect(described_class.eligible?(eligible_date)).to be true
    end
  end
end
