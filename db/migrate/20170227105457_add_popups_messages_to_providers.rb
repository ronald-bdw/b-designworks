class AddPopupsMessagesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :first_popup_message, :text
    add_column :providers, :second_popup_message, :text
  end
end
