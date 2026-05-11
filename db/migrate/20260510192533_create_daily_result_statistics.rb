class CreateDailyResultStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_result_statistics do |t|
      t.date :date, null: false
      t.string :subject, null: false

      t.integer :daily_low, null: false
      t.integer :daily_high, null: false
      t.integer :result_count, null: false

      t.timestamps
    end

    add_index :daily_result_statistics,
              [:date, :subject],
              unique: true
  end
end