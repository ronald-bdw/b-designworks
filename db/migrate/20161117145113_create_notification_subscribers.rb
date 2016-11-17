class CreateNotificationSubscribers < ActiveRecord::Migration
  def change
    create_table :notification_subscribers do |t|
      t.string :email, null: false
      t.string :notification_types, array: true, default: []
    end

    add_index :notification_subscribers, :email, unique: true
    add_index :notification_subscribers, :notification_types, using: "gin"
  end
end
