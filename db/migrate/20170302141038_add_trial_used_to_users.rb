class AddTrialUsedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_used, :boolean, default: false, null: false
  end
end
