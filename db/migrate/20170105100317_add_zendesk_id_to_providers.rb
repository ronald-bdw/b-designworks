class AddZendeskIdToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :zendesk_id, :string
  end
end
