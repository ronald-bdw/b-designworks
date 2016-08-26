require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Sessions" do
  header "Accept", "application/json"

  subject(:response) { json_response_body }

  post "/v1/users/sign_in" do
    let(:user) { create :user }
    let(:auth_phone_code) { create :auth_phone_code, user: user, expire_at: 2.days.from_now }

    parameter :phone_number, "Phone Number", required: true
    parameter :auth_phone_code, "Auth phone code", required: true
    parameter :sms_code, "Sms Code", required: true

    context "with valid params" do
      let(:params) do
        {
          phone_number: user.phone_number,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "Sign in with phone number" do
        user.reload
        expect(response_status).to eq 201
        expect(response["user"]).to be_a_user_representation(user)
      end
    end

    context "with invalid phone number" do
      let(:error_message) { "Phone number is invalid" }

      let(:params) do
        {
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "Sign in without phone number", document: false do
        expect(response_status).to eq 401
        expect(response).to be_an_error_representation(:unauthorized, error_message)
      end
    end

    context "with invalid sms code" do
      let(:error_message) { "Sms code is invalid" }

      let(:params) do
        {
          phone_number: user.phone_number,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: "invalid"
        }
      end

      example_request "Sign in with invalid sms code", document: false do
        expect(response_status).to eq 401
        expect(response).to be_an_error_representation(:unauthorized, error_message)
      end
    end
  end
end
