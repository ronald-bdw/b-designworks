require "rails_helper"

describe GenerateAuthPhoneCode do
  describe ".call" do
    subject(:interactor) { described_class.call(phone_number: user.phone_number, device_type: "android") }

    let(:generator) { double "generator", phone_code: "1234", expire_at: Time.zone.now + 10.minutes }
    let(:user) { build_stubbed :user }
    let(:auth_phone_code) { interactor.auth_phone_code }

    before do
      allow(AuthCodeGenerator).to receive(:new).and_return(generator)
    end

    it "generates phone code and expire at" do
      expect(auth_phone_code.phone_code).to eq(generator.phone_code)
      expect(auth_phone_code.expire_at).to eq(generator.expire_at)
    end
  end
end
