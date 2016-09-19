class Provider < ActiveRecord::Base
  DEFAULT_PROVIDER_NAME = "HBF"

  has_many :users

  validates :name, presence: true
end
