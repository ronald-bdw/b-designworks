require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Zendesk Organization" do
  include_context "zendesk app"
  header "Accept", "application/json"

  put "/v1/zendesk/organizations/:zendesk_id" do
    let(:provider) { create :provider }
    let(:zendesk_id) { provider.zendesk_id }
    let(:name) { "HBF" }
    let(:priority) { 1 }

    parameter :zendesk_id, "Organization's zendesk id", required: true
    parameter :name, "Organization's name", scope: :organization
    parameter :priority, "Organization's priority", scope: :organization

    example_request "Zendesk app update organization" do
      provider.reload

      expect(provider.name).to eq "HBF"
      expect(provider.priority).to eq 1
    end
  end

  post "/v1/zendesk/organizations/fetch" do
    before { stub_zendesk_all_organizations }

    let(:notify_email) { "homer.simpson@example.com" }
    let(:email) { open_last_email_for(notify_email) }

    parameter :notify_email, "Admin's email to notify"

    example_request "Create or update organizations from zendesk" do
      expect(status).to eq(201)
      expect(json_response_body).to have_key("job_id")
      expect(email).to have_subject("Organizations are imported")
    end
  end
end
