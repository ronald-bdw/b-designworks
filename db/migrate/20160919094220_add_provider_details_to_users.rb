class AddProviderDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :project_id, :string
    add_column :users, :member_number, :string
    add_column :users, :street_number, :string
    add_column :users, :street_name, :string
    add_column :users, :street_type, :string
    add_column :users, :suburb, :string
    add_column :users, :state, :string
    add_column :users, :postcode, :string
  end
end
