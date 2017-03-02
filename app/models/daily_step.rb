class DailyStep < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider

  enum source: %i(healthkit googlefit fitbit)
end
