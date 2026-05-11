require 'rails_helper'

RSpec.describe TestResult, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:student_name) }
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:submitted_at) }

    it do
      should validate_numericality_of(:marks)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it 'normalizes text fields before validation' do
      result = described_class.create!(
        student_name: '  Palak  ',
        subject: '  Math  ',
        marks: 88,
        submitted_at: Time.current
      )

      expect(result.student_name).to eq('Palak')
      expect(result.subject).to eq('Math')
    end
  end
end
