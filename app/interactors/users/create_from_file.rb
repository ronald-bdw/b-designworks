module Users
  class CreateFromFile
    include Interactor

    XLSX_COLUMNS = %i(
      project_id
      member_number
      first_name
      last_name
      phone_number
      email
      street_number
      street_name
      street_type
      suburb
      state
      postcode
    ).freeze

    delegate :file, :invalid_users, to: :context

    before do
      context.invalid_users = []
    end

    def call
      worksheet = RubyXL::Parser.parse(file).worksheets[0]
      worksheet.delete_row(0)

      worksheet.each do |row|
        user = default_provider.users.build(build_params(row: row))

        invalid_users << user unless user.save
      end

      context.fail! unless invalid_users.empty?
    end

    private

    def build_params(row:)
      params_array = XLSX_COLUMNS.zip(row.cells.map(&:value))

      Hash[params_array]
    end

    def default_provider
      @provider ||= Provider.find_or_create_by(name: Provider::DEFAULT_PROVIDER_NAME)
    end
  end
end
