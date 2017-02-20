class AddFieldsToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :subscriber, :boolean, null: false, default: false
    add_column :providers, :expiration_interval, :integer, null: false, default: 60
  end
end
