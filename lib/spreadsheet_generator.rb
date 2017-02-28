require "spreadsheet"

class SpreadsheetGenerator
  attr_reader :provider
  private :provider

  def initialize(provider)
    Spreadsheet.client_encoding = 'UTF-8'
    @provider = provider
  end

  def generate
    month_intervals.each_with_index do |(month_name, interval), index|
      sheet = book.create_worksheet name: month_name
      sheet.row(0).concat headers(month_name)
      row_count = 0
      User.where(id: [10797, 10286, 8659, 8370, 365, 356, 339, 369, 328], provider: provider).each_with_index do |user, i|
        user_fields = %i(project_id first_name last_name email provider_name)
        attrs = user_fields.map { |field| user.send(field) || 0 }
        %i(fitbit googlefit healthkit).each do |source|
          user_steps = activities(user, source, interval)
          if user_steps.present?
            row_count += 1
            options = {
              user: user,
              source: source,
              user_steps: user_steps,
              interval: interval
            }
            sheet.row(row_count).concat(build_steps_count(options))
          end
        end
      end
    end
    file_contents = "#{Rails.root}/export.xls" #StringIO.new
    file = book.write(file_contents)
    file
  end

  def headers(month_name)
    main_headers = %w{ProjectId FirstName LastName Email Organization Fitbit GoogleFit Health}
    month_intervals[month_name].each do |interval|
      main_headers << interval.strftime("%-d-%b")
    end
    main_headers
  end

  private

  def book
    @book ||= Spreadsheet::Excel::Workbook.new
  end

  def month_intervals
    Date::MONTHNAMES.compact.reduce({}) do |intervals, month|
      intervals.merge!(month => (Date.parse(month)..Date.parse(month).end_of_month))
      intervals
    end
  end

  def activities(user, source, month_interval)
    user.activities
      .send(source).where(started_at: month_interval)
      .group_by_period(:day, :started_at, last: nil)
      .sum(:steps_count)
  end

  def user_attributes(user)
    %i(project_id first_name last_name email provider_name).map do |field|
      user.send(field) || 0
    end
  end

  def empty_steps(interval)
    interval.reduce({}) {|m, date| m.merge!(date => 0) }
  end

  def steps_by_day(options)
    empty_steps(options[:interval]).merge(options[:user_steps]).values
  end

  def sources_list(source)
    %i(fitbit googlefit healthkit).map do |type|
      type == source ? 1 : 0
    end
  end

  def build_steps_count(options)
    [
      user_attributes(options[:user]),
      sources_list(options[:source]),
      steps_by_day(options)
    ].flatten
  end
end
