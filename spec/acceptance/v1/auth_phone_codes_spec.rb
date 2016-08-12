require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Authentication phone codes" do
  header "Accept", "application/json"

  post "v1/auth_phone_codes" do
    subject(:response) { json_response_body["auth_phone_code"] }

    parameter :phone_number, "Phone number", required: true

    context "when user is registered" do
      let(:user) { create :user }
      let(:phone_number) { user.phone_number }

      example_request "Send auth code to phone number" do
        byebug
        expect(response["phone_registered"]).to be_truthy
      end
    end

    context "when user is not registered" do
      let(:phone_number) { Faker::PhoneNumber.cell_phone }

      example_request "Send auth code to phone number" do
        expect(response["phone_registered"]).to be_falsey
      end
    end
  end
end
