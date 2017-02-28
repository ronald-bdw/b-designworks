class AddPopupsMessagesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :first_popup_message, :text, default: "", null: false
    add_column :providers, :second_popup_message, :text, default: "", null: false
  end
end
