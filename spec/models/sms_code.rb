require "rails_helper"

describe SmsCode do
  describe "validations" do
    let(:phone_code) { auth_phone_code.phone_code }

    subject do
      described_class.new(
        phone_code,
        sms_code
      )
    end

    let(:auth_phone_code) { build_stubbed :auth_phone_code }

    context "with valid sms code" do
      let(:sms_code) { auth_phone_code.phone_code }
      it "check with correct sms code" do
        expect(subject).to be_valid
      end
    end

    context "with invalid sms code" do
      let(:sms_code) { "fqwef" }
      let(:error_messages) { { phone_code: ["invalid sms code"] } }

      it "should contains error messages" do
        subject.valid?

        error_messages.each do |field, value|
          expect(subject.errors.messages[field]).to eq value
        end
      end

      it "check with correct sms code" do
        expect(subject).not_to be_valid
      end
    end
  end
end
