class MonthlyAverageJob < ApplicationJob
  queue_as :default

  def perform(date = Date.current)
    return unless DateRules::MonthlyAverageEligibility
                    .eligible?(date)

    Statistics::MonthlyAverageCalculator.call(date)
  end
end