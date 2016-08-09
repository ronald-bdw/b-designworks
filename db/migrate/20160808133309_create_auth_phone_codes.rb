class CreateAuthPhoneCodes < ActiveRecord::Migration
  def change
    create_table :auth_phone_codes do |t|
      t.belongs_to :user, index: true
      t.string :phone_code
      t.datetime :expire_at

      t.timestamps
    end
  end
end
