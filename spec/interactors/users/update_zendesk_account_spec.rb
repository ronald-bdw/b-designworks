require "rails_helper"

describe Users::UpdateZendeskAccount do
  describe ".call" do
    subject(:interactor) { described_class.call(user: user) }

    let(:user) { build_stubbed :user, zendesk_id: zendesk_user.id }
    let(:zendesk_user) { double :zendesk_user, id: "111" }

    before do
      allow(ZendeskAPI::User).to receive(:update!).and_return(zendesk_user)
      allow(user).to receive(:save)
    end

    context "when user is invalid" do
      before do
        allow(user).to receive(:invalid?).and_return(true)
      end

      it "doesn't update zendesk account" do
        interactor

        expect(ZendeskAPI::User).to_not have_received(:update!)
      end
    end

    context "when user is valid" do
      it "updates zendesk account" do
        interactor

        expect(ZendeskAPI::User).to have_received(:update!)
        expect(user.zendesk_id).to eq(zendesk_user.id)
      end
    end
  end
end
