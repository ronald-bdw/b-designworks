class Provider < ActiveRecord::Base
  DEFAULT_PROVIDER_NAME = "HBF".freeze

  has_many :users

  scope :not_subscriber, -> { where(subscriber: false) }

  validates :name, presence: true

  def self.default
    find_or_create_by(name: DEFAULT_PROVIDER_NAME)
  end
end
