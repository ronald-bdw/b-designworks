require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Zendesk User" do
  include_context "zendesk app"
  header "Accept", "application/json"

  patch "/v1/zendesk/users/:zendesk_id" do
    let(:user) { create :user }
    let(:zendesk_id) { user.zendesk_id }
    let(:email) { "homer.simpson@example.com" }
    let(:name) { "Homer Simpson" }

    parameter :zendesk_id, "User's zendesk id", required: true
    parameter :email, "User's email address", scope: :user
    parameter :name, "User's name", scope: :user

    example_request "Zendesk app update user" do
      user.reload

      expect(user.email).to eq("homer.simpson@example.com")
      expect(user.first_name).to eq("Homer")
      expect(user.last_name).to eq("Simpson")
    end
  end
end
