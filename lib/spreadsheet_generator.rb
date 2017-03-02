require "spreadsheet"

class SpreadsheetGenerator
  attr_reader :provider, :year
  private :provider, :year

  def initialize(provider, year)
    Spreadsheet.client_encoding = "UTF-8"

    @provider = provider
    @year = year
  end

  def generate
    month_intervals.each do |month_name, interval|
      sheet = Sheet.new(
        name: month_name,
        interval: interval,
        headers: headers(month_name)
      )
      book.add_worksheet(sheet)
      sheet.fill_sheet(provider.id, interval)
    end

    file_path = "#{Rails.root}/tmp/export_#{Time.current}.xls"
    book.write(file_path)

    file_path
  end

  private

  def headers(month_name)
    month_intervals[month_name].map do |interval|
      interval.strftime("%-d-%b")
    end
  end

  def book
    @book ||= Spreadsheet::Excel::Workbook.new
  end

  def month_intervals
    Date::MONTHNAMES.compact.reduce({}) do |intervals, month|
      month_year = [month, year].join(", ")
      intervals[month] = (Date.parse(month_year).beginning_of_month..Date.parse(month_year).end_of_month)
      intervals
    end
  end
end
