class AddSourceToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :source, :integer, null: false
  end
end
