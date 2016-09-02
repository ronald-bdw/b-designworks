require "rails_helper"

describe SendNotifier do
  describe ".call" do
    subject(:interactor) do
      described_class.call(
        phone_number: phone_number,
        message: message
      )
    end

    context "success" do
      let(:phone_number) { attributes_for(:user).slice(:phone_number) }
      let(:client) { double :client, messages: double }
      let(:phone_code) { Faker::Number.number(4) }
      let(:message) { I18n.t("auth_phone_code.phone_code.verification", phone_code: "1234") }

      let(:sms_params) do
        {
          from: "+15005550006",
          to: phone_number,
          body: message
        }
      end

      before do
        allow(Twilio::REST::Client).to receive(:new).and_return(client)
        allow(client.messages).to receive(:create)
      end

      it "does send sms message" do
        interactor
        expect(Twilio::REST::Client).to have_received(:new)
        expect(client.messages).to have_received(:create).with(sms_params)
      end
    end

    context "failure" do
      let(:message) { "The 'To' number #{phone_number} is not a valid phone number." }
      let(:phone_number) { "7906333222" }
      let(:errors) { { message: [message] } }

      before do
        allow(Twilio::REST::Client).to receive_message_chain(:new, :messages, :create)
          .and_raise(Twilio::REST::RequestError, message)
      end

      it "returns error message" do
        expect(interactor.failure?).to be_truthy
        expect(interactor.errors).to eq(errors)
      end
    end
  end
end
