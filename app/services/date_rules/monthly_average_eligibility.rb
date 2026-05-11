module DateRules
  class MonthlyAverageEligibility
    class << self
      def eligible?(date)
        day = date.to_date
        third_wednesday = third_wednesday_for(day.year, day.month)

        day == third_wednesday.beginning_of_week(:monday)
      end

      private

      def third_wednesday_for(year, month)
        first_day = Date.new(year, month, 1)
        days_until_wednesday = (3 - first_day.wday) % 7

        first_day + days_until_wednesday.days + 2.weeks
      end
    end
  end
end
