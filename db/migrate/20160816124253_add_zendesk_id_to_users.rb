class AddZendeskIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zendesk_id, :integer
  end
end
