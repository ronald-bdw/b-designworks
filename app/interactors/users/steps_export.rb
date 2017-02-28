module Users
  class StepsExport
    include Interactor

    delegate :provider, to: :context

    def call
      context.file = SpreadsheetGenerator.new(provider).generate
    end
  end
end
