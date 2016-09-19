require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users collection" do
  include_context "zendesk app"

  post "/v1/users_collection" do
    parameter :file, "XLSX file with users data"

    context "with valid xlsx file" do
      let(:file) do
        fixture_file_upload(
          "spec/fixtures/files/valid_users_collection.xlsx",
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end

      example_request "returns created status" do
        expect(status).to eq(201)
      end
    end

    context "with invalid xlsx file" do
      let(:file) do
        fixture_file_upload(
          "spec/fixtures/files/invalid_users_collection.xlsx",
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
      end

      example_request "return unprocessable entity status" do
        expect(status).to eq(422)
        expect(response_body).to include("users")
      end
    end
  end
end
