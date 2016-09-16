class CreateFitnessTokens < ActiveRecord::Migration
  def change
    create_table :fitness_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.string :token, null: false
      t.integer :source, null: false
      t.string :refresh_token

      t.timestamps null: false
    end
  end
end
