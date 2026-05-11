# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_12_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_result_statistics", force: :cascade do |t|
    t.date "date", null: false
    t.string "subject", null: false
    t.integer "daily_low", null: false
    t.integer "daily_high", null: false
    t.integer "result_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "subject"], name: "index_daily_result_statistics_on_date_and_subject", unique: true
    t.check_constraint "daily_high >= 0 AND daily_high <= 100", name: "daily_result_statistics_high_between_0_and_100"
    t.check_constraint "daily_low <= daily_high", name: "daily_result_statistics_low_lte_high"
    t.check_constraint "daily_low >= 0 AND daily_low <= 100", name: "daily_result_statistics_low_between_0_and_100"
    t.check_constraint "result_count > 0", name: "daily_result_statistics_result_count_positive"
  end

  create_table "monthly_result_averages", force: :cascade do |t|
    t.date "calculated_on", null: false
    t.string "subject", null: false
    t.decimal "average_daily_high", precision: 5, scale: 2, null: false
    t.decimal "average_daily_low", precision: 5, scale: 2, null: false
    t.integer "total_result_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calculated_on", "subject"], name: "index_monthly_result_averages_on_calculated_on_and_subject", unique: true
    t.check_constraint "average_daily_high >= 0::numeric AND average_daily_high <= 100::numeric", name: "monthly_result_averages_high_between_0_and_100"
    t.check_constraint "average_daily_low >= 0::numeric AND average_daily_low <= 100::numeric", name: "monthly_result_averages_low_between_0_and_100"
    t.check_constraint "total_result_count > 0", name: "monthly_result_averages_total_count_positive"
  end

  create_table "test_results", force: :cascade do |t|
    t.string "student_name", null: false
    t.string "subject", null: false
    t.integer "marks", null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submitted_at", "subject"], name: "index_test_results_on_submitted_at_and_subject"
    t.index ["submitted_at"], name: "index_test_results_on_submitted_at"
    t.check_constraint "marks >= 0 AND marks <= 100", name: "test_results_marks_between_0_and_100"
  end

end
