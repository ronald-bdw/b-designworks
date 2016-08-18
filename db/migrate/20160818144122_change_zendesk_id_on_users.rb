class ChangeZendeskIdOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :zendesk_id, :string
  end

  def down
    change_column :users, :zendesk_id, 'integer USING CAST(zendesk_id AS integer)'
  end
end
