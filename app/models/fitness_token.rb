class FitnessToken < ActiveRecord::Base
  belongs_to :user

  attr_accessor :authorization_code

  validates :source, :token, presence: true
  validates :source, uniqueness: { scope: :user }

  enum source: %i(googlefit fitbit)
end
