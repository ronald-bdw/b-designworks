class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.string :plan_name
      t.timestamp :expires_at, null: false
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
