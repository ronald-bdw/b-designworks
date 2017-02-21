class AddPurchasedAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :purchased_at, :datetime
  end
end
