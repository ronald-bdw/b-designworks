require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Registrations" do
  header "Accept", "application/json"

  let(:user) { create :user }
  let(:auth_phone_code) { create :auth_phone_code, user: user, expire_at: 2.days.from_now }
  let(:user_params) do
    attributes_for(:user).slice(
      :full_name,
      :email,
      :phone_number
    )
  end

  subject(:response) { json_response_body }

  post "/v1/users" do
    parameter :full_name, "Full name", required: true
    parameter :email, "Email", required: true
    parameter :phone_number, "Phone number", required: true

    context "with valid params" do
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "create user with phone number" do
        expect(response["user"]).to be_a_user_representation(User.last)
      end
    end

    context "with invalid phone number" do
      let(:params) do
        {
          user: user_params.except(:phone_number),
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      example_request "create user without phone number" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, "phone_number" => ["can't be blank"])
      end
    end

    context "with invalid sms code" do
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: "invalid_code"
        }
      end

      example_request "create user with invalid sms code" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, { "sms_code" => ["is invalid"] })
      end
    end

    context "with expired sms code" do
      let(:params) do
        {
          user: user_params,
          auth_phone_code_id: auth_phone_code.id,
          sms_code: auth_phone_code.phone_code
        }
      end

      let(:auth_phone_code) { create :auth_phone_code, user: user, expire_at: 5.minutes.ago }

      example_request "create user with invalid sms code" do
        expect(response_status).to eq 422
        expect(response).to be_an_validation_error_representation(:unprocessable_entity, { "sms_code" => ["is expired"] })
      end
    end
  end
end
