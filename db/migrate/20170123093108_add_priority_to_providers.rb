class AddPriorityToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :priority, :integer
  end
end
