class CreateMonthlyResultAverages < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_result_averages do |t|
      t.date :calculated_on, null: false
      t.string :subject, null: false

      t.decimal :average_daily_high, null: false
      t.decimal :average_daily_low, null: false

      t.integer :total_result_count, null: false

      t.timestamps
    end
  end
end