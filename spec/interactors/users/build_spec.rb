require "rails_helper"

describe Users::Build do
  describe ".call" do
    subject(:interactor) do
      described_class.call(
        user_params: user_params,
        auth_phone_code: auth_phone_code,
        sms_auth_code: sms_code
      )
    end

    let(:user_params) { attributes_for(:user).slice(:first_name, :last_name, :email, :phone_number) }
    let(:auth_phone_code) { build_stubbed :auth_phone_code }

    context "with valid params" do
      let(:sms_code) { auth_phone_code.phone_code }

      it "assigns auth phone code" do
        expect(interactor.user.auth_phone_code).to eq(auth_phone_code)
      end
    end

    context "with invalid params" do
      let(:sms_code) { "adff" }
      let(:error_messages) { { sms_code: ["is invalid"] } }

      it "adds sms errors to user" do
        error_messages.each do |field, value|
          expect(interactor.user.errors.messages[field]).to eq value
        end
      end
    end
  end
end
