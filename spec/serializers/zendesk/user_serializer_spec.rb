require "rails_helper"

describe Zendesk::UserSerializer do
  let(:user) { build :user, id: 1, authentication_token: "token" }
  let(:json) { ActiveModel::SerializableResource.serialize(user, serializer: described_class).to_json }
  let(:user_json) { parse_json(json)["user"] }

  describe "subscription plan name" do
    subject(:plan_name) { user_json["subscription"]["plan_name"] }

    context "when user hasn't subscription" do
      it { is_expected.to eq("Provider") }
    end

    context "when user subscription has purchased date" do
      let(:purchased_at) { Time.current }
      before { user.subscription = build(:subscription, purchased_at: purchased_at) }

      it { is_expected.to eq("Trial (#{purchased_at})") }
    end

    context "when user subscription hasn't purchased date" do
      before { user.subscription = build(:subscription) }

      it { is_expected.to eq("Trial") }
    end
  end
end
