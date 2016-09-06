require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Authentication phone codes" do
  header "Accept", "application/json"
  let(:message) { double :message, create: true }

  post "v1/auth_phone_codes" do
    subject(:response) { json_response_body["auth_phone_code"] }

    parameter :phone_number, "Phone number", required: true

    context "with valid phone number" do
      before do
        allow_any_instance_of(Twilio::REST::Client).to receive(:messages).and_return(message)
      end

      context "when user is registered" do
        let(:user) { create :user }
        let(:phone_number) { user.phone_number }

        example_request "Send auth code to registered user phone number " do
          expect(response["phone_registered"]).to be_truthy
        end
      end

      context "when user is not registered", document: false do
        let(:phone_number) { Faker::PhoneNumber.cell_phone }

        example_request "Send auth code to not registered user phone number" do
          expect(response["phone_registered"]).to be_falsey
        end
      end
    end

    context "with invalid phone number", document: false do
      let(:phone_number)  { "71112223330" }

      before do
        allow(Twilio::REST::Client).to receive_message_chain(:new, :messages, :create)
          .and_raise(Twilio::REST::RequestError, nil)
      end

      example_request "Send auth code to invalid phone number" do
        expect(response_status).to eq 422
        expect(json_response_body).to be_an_error_representation(:unprocessable_entity)
      end
    end
  end
end
