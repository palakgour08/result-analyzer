module Statistics
  class DailyCalculator
    class << self
      def call(date)
        day = date.to_date
        rows = rows_for(day)

        return if rows.empty?

        DailyResultStatistic.upsert_all(
          rows,
          unique_by: :index_daily_result_statistics_on_date_and_subject,
          update_only: [:daily_low, :daily_high, :result_count]
        )
      end

      private

      def rows_for(day)
        timestamp = Time.current

        TestResult
          .where(submitted_at: day.all_day)
          .group(:subject)
          .pluck(
            :subject,
            Arel.sql("MIN(marks)"),
            Arel.sql("MAX(marks)"),
            Arel.sql("COUNT(*)")
          )
          .map do |subject, daily_low, daily_high, result_count|
            {
              date: day,
              subject: subject,
              daily_low: daily_low,
              daily_high: daily_high,
              result_count: result_count,
              created_at: timestamp,
              updated_at: timestamp
            }
          end
      end
    end
  end
end
