require "rails_helper"

describe SendNotifier do
  describe ".call" do
    subject(:interactor) do
      described_class.call(
        phone_number: user_params[:phone_number],
        message: message
      )
    end

    let(:user_params) { attributes_for(:user).slice(:phone_number) }
    let(:phone_code) { Faker::Number.number(4) }
    let(:message) { I18n.t("auth_phone_code.phone_code.verification", phone_code: "1234") }
    let(:client) { double :client, messages: double }
    let(:sms_params) do
      {
        from: "+15005550006",
        to: user_params[:phone_number],
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
end
