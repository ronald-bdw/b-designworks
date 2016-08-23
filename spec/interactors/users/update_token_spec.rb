require "rails_helper"

describe Users::UpdateToken do
  describe ".call" do
    let!(:user) { create :user }
    let!(:old_authentication_token) { user.authentication_token }
    subject(:interactor) { described_class.call(user: user) }

    it "does update the user token" do
      interactor
      expect(user.authentication_token).not_to eq(old_authentication_token)
    end
  end
end
