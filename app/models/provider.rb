class Provider < ActiveRecord::Base
  has_many :users

  validates :name, length: { minimum: 3 }
end
