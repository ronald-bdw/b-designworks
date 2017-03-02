class AddFieldsToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :subscriber, :boolean, null: false, default: false
  end
end
