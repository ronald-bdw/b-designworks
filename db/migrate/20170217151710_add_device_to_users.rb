class AddDeviceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device, :string, default: ""
  end
end
