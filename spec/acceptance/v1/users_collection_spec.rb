require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users collection" do
  include_context "zendesk app"

  post "/v1/users_collection" do
    parameter :file, "XLSX file with users data"

    let(:file) do
      fixture_file_upload(
        "spec/fixtures/files/users_collection.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
    end

    example_request "returns created status" do
      expect(status).to eq(201)
    end
  end
end
