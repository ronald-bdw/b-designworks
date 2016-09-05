class CreateProviders < ActiveRecord::Migration
  def up
    create_table :providers do |t|
      t.string :name, null: false
    end

    add_column :users, :provider_id, :integer
    add_index :users, :provider_id
  end

  def down
    remove_column :users, :provider_id

    drop_table :providers
  end
end
