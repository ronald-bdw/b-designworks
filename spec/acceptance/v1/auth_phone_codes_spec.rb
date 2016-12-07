require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Authentication phone codes" do
  header "Accept", "application/json"

  let(:message) { double :message, create: true }

  post "v1/auth_phone_codes" do
    subject(:response) { json_response_body["auth_phone_code"] }

    parameter :phone_number, "Phone number", required: true
    parameter :device_type, "User device type", required: true

    context "with valid phone number" do
      before do
        allow_any_instance_of(Twilio::REST::Client).to receive(:messages).and_return(message)
      end

      context "when user is registered" do
        let(:user) { create :user }
        let(:phone_number) { user.phone_number }
        let(:device_type) { "ios" }

        example_request "Send auth code to registered user phone number " do
          expect(response["phone_registered"]).to be_truthy
        end
      end

      context "when user is not registered", document: false do
        let(:phone_number) { Faker::PhoneNumber.cell_phone }
        let(:device_type) { "ios" }

        example_request "Send auth code to not registered user phone number" do
          expect(response["phone_registered"]).to be_falsey
        end
      end
    end

    context "with invalid phone number", document: false do
      let(:phone_number)  { "71112223330" }
      let(:device_type) { "ios" }
      let(:error_message) { { "phone_number" => ["is invalid"] } }

      before do
        allow(Twilio::REST::Client).to receive_message_chain(:new, :messages, :create)
          .and_raise(Twilio::REST::RequestError, nil)
      end

      example_request "Send auth code to invalid phone number" do
        expect(response_status).to eq 422
        expect(json_response_body).to be_an_validation_error_representation(:unprocessable_entity, error_message)
      end
    end
  end

  post "v1/auth_phone_codes/:id/check" do
    parameter :id, "Auth phone code's id", required: true
    parameter :sms_code, "A code that user received from sms", required: true

    let!(:auth_phone_code) { create :auth_phone_code }
    let(:id) { auth_phone_code.id }
    let(:sms_code) { auth_phone_code.phone_code }

    example_request "Check user's sms code" do
      expect(status).to eq(200)
    end

    context "with invalid params", document: false do
      let(:sms_code) { "some code" }

      example_request "Check invalid sms code" do
        expect(status).to eq(422)
      end
    end
  end
end
