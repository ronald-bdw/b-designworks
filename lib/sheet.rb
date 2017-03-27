require "spreadsheet"

class Sheet < Spreadsheet::Worksheet
  attr_reader :headers
  private :headers

  MAIN_HEADERS = %w(
    ProjectId
    FirstName
    LastName
    Email
    Organization
    PreviousOrganization
    Fitbit
    GoogleFit
    Health
  ).freeze

  def initialize(options)
    @headers = options[:headers]
    super
  end

  def fill_sheet(provider_id, interval)
    row(0).concat [MAIN_HEADERS, headers].flatten
    user_id = 0

    UserDailySteps.new(provider_id, interval).all.each_with_index do |activity, index|
      options = {
        activity: activity,
        source: activity["source"].to_i,
        interval: interval,
        new_user: user_id != activity["user_id"].to_i
      }
      user_id = activity["user_id"].to_i

      row(index + 1).concat(SheetRow.new(options).build)
    end

    self
  end
end
