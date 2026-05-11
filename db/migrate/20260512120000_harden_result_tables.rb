class HardenResultTables < ActiveRecord::Migration[7.1]
  def change
    change_column_null :test_results, :student_name, false
    change_column_null :test_results, :subject, false
    change_column_null :test_results, :marks, false
    change_column_null :test_results, :submitted_at, false

    add_index :test_results, :submitted_at
    add_index :test_results, [:submitted_at, :subject]
    add_check_constraint :test_results,
                         "marks >= 0 AND marks <= 100",
                         name: "test_results_marks_between_0_and_100"

    add_check_constraint :daily_result_statistics,
                         "daily_low >= 0 AND daily_low <= 100",
                         name: "daily_result_statistics_low_between_0_and_100"
    add_check_constraint :daily_result_statistics,
                         "daily_high >= 0 AND daily_high <= 100",
                         name: "daily_result_statistics_high_between_0_and_100"
    add_check_constraint :daily_result_statistics,
                         "daily_low <= daily_high",
                         name: "daily_result_statistics_low_lte_high"
    add_check_constraint :daily_result_statistics,
                         "result_count > 0",
                         name: "daily_result_statistics_result_count_positive"

    change_column :monthly_result_averages,
                  :average_daily_high,
                  :decimal,
                  precision: 5,
                  scale: 2,
                  null: false
    change_column :monthly_result_averages,
                  :average_daily_low,
                  :decimal,
                  precision: 5,
                  scale: 2,
                  null: false
    add_index :monthly_result_averages,
              [:calculated_on, :subject],
              unique: true
    add_check_constraint :monthly_result_averages,
                         "average_daily_low >= 0 AND average_daily_low <= 100",
                         name: "monthly_result_averages_low_between_0_and_100"
    add_check_constraint :monthly_result_averages,
                         "average_daily_high >= 0 AND average_daily_high <= 100",
                         name: "monthly_result_averages_high_between_0_and_100"
    add_check_constraint :monthly_result_averages,
                         "total_result_count > 0",
                         name: "monthly_result_averages_total_count_positive"
  end
end
