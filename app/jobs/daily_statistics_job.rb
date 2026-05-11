class DailyStatisticsJob < ApplicationJob
  queue_as :default

  def perform(date = Date.current)
    Statistics::DailyCalculator.call(date)
  end
end