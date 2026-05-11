class CreateTestResults < ActiveRecord::Migration[7.1]
  def change
    create_table :test_results do |t|
      t.string :student_name
      t.string :subject
      t.integer :marks
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
