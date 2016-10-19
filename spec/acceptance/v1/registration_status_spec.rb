require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users registration status" do
  header "Accept", "application/json"

  post "/v1/registration_status" do
    parameter :phone_number, "Users phone number"

    let(:phone_number) { attributes_for(:user)[:phone_number] }

    example_request "Get users registration status" do
      expect(status).to eq(201)
      expect(json_response_body).to include("phone_registered" => false)
    end
  end
end
