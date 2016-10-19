class FitnessToken < ActiveRecord::Base
  belongs_to :user

  attr_accessor :authorization_code

  validates :source, :token, presence: true

  enum source: %i(googlefit fitbit)
end
