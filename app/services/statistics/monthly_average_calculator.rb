module Statistics
  class MonthlyAverageCalculator
    MINIMUM_RESULT_COUNT = 200

    class << self
      def call(date)
        new(date).call
      end
    end

    def initialize(date)
      @calculated_on = date.to_date
    end

    def call
      rows = subjects.filter_map do |subject|
        statistics = statistics_for(subject)
        next if statistics.empty?

        row_for(subject, statistics)
      end

      return if rows.empty?

      MonthlyResultAverage.upsert_all(
        rows,
        unique_by: :index_monthly_result_averages_on_calculated_on_and_subject,
        update_only: [
          :average_daily_high,
          :average_daily_low,
          :total_result_count
        ]
      )
    end

    private

    attr_reader :calculated_on

    def subjects
      DailyResultStatistic
        .where(date: ..calculated_on)
        .distinct
        .order(:subject)
        .pluck(:subject)
    end

    def statistics_for(subject)
      selected = []
      total_result_count = 0

      DailyResultStatistic
        .where(subject: subject, date: ..calculated_on)
        .order(date: :desc)
        .each do |statistic|
          selected << statistic
          total_result_count += statistic.result_count

          break if selected.size >= 5 && total_result_count >= MINIMUM_RESULT_COUNT
        end

      selected
    end

    def average(attribute, statistics)
      statistics.sum(&attribute).to_d / statistics.size
    end

    def row_for(subject, statistics)
      timestamp = Time.current

      {
        calculated_on: calculated_on,
        subject: subject,
        average_daily_high: average(:daily_high, statistics),
        average_daily_low: average(:daily_low, statistics),
        total_result_count: statistics.sum(&:result_count),
        created_at: timestamp,
        updated_at: timestamp
      }
    end
  end
end
