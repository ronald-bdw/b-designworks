class CreateDailySteps < ActiveRecord::Migration
  def change
    create_table :daily_steps do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :provider
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false
      t.integer :steps_count, null: false
      t.integer :source, null: false

      t.timestamps null: false
    end
  end
end
