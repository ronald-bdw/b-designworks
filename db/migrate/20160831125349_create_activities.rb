class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :user, index: true, null: false
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false
      t.integer :steps_count, null: false
      t.timestamps
    end
  end
end
