class TestResult < ApplicationRecord
  before_validation :normalize_text_fields

  validates :student_name, presence: true
  validates :subject, presence: true
  validates :submitted_at, presence: true

  validates :marks,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  private

  def normalize_text_fields
    self.student_name = student_name.to_s.strip.presence
    self.subject = subject.to_s.strip.presence
  end
end
