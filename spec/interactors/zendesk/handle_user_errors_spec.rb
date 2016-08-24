require "rails_helper"

describe Zendesk::HandleUserErrors do
  describe ".call" do
    let(:zendesk_user) { double :zendesk_user, errors: { "email" => [{ "error" => "DuplicateValue" }] } }
    let(:parsed_errors) { { email: ["has already been taken"] } }

    subject(:interactor) { described_class.call(zendesk_user: zendesk_user) }

    it "parses errors in active record way" do
      expect(interactor.errors).to eq(parsed_errors)
    end
  end
end
