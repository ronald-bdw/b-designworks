class FitnessToken < ActiveRecord::Base
  belongs_to :user

  attr_accessor :authorization_code

  validates :source, :token, presence: true

  scope :source_fitbit, -> { where(source: sources["fitbit"]) }
  scope :source_googlefit, -> { where(source: sources["googlefit"]) }

  enum source: %i(googlefit fitbit)
end
