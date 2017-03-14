class AddPreviousProviderIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :previous_provider_id, :integer
  end
end
