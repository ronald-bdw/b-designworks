class AddPopupsAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_popup_active, :boolean, default: false, null: false
    add_column :users, :second_popup_active, :boolean, default: false, null: false
  end
end
