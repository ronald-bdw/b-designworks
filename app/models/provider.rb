class Provider < ActiveRecord::Base
  DEFAULT_PROVIDER_NAME = "HBF".freeze

  has_many :users

  validates :name, presence: true
end
