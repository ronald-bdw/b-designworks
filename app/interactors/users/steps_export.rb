module Users
  class StepsExport
    include Interactor

    delegate :provider, :year, to: :context

    def call
      file_path = SpreadsheetGenerator.new(provider, year).generate
      context.file = ::Users::AwsUploader.call(file_path: file_path).file
    end
  end
end
