class RemovePasswordFromUsers < ActiveRecord::Migration
  def up
    remove_index :users, :reset_password_token

    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
  end

  def down
    add_column :users, :encrypted_password, :string, default: "", null: false
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    add_index :users, :reset_password_token, unique: true
  end
end
