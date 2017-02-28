require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Zendesk User" do
  include_context "zendesk app"
  header "Accept", "application/json"

  get "/v1/zendesk/users/:zendesk_id" do
    let(:user) { create :user }
    let(:zendesk_id) { user.zendesk_id }
    let(:user_json) { json_response_body["user"] }

    parameter :zendesk_id, "User's zendesk id", required: true

    example_request "Get user info" do
      expect(status).to eq(200)
      expect(user_json).to be_a_zendesk_user_representation
    end
  end

  put "/v1/zendesk/users/:zendesk_id" do
    let(:user) { create :user }
    let(:zendesk_id) { user.zendesk_id }
    let(:email) { "homer.simpson@example.com" }
    let(:name) { "Homer Simpson" }
    let(:first_popup_active) { "true" }
    let(:second_popup_active) { "false" }

    parameter :zendesk_id, "User's zendesk id", required: true
    parameter :email, "User's email address", scope: :user
    parameter :name, "User's name", scope: :user
    parameter :first_popup_active, "Popup active checkbox", scope: :user
    parameter :second_popup_active, "Urgent popup active checkbox", scope: :user

    example_request "Zendesk app update user" do
      user.reload

      expect(user.email).to eq("homer.simpson@example.com")
      expect(user.first_name).to eq("Homer")
      expect(user.last_name).to eq("Simpson")
      expect(user.first_popup_active).to be_truthy
      expect(user.second_popup_active).to be_falsey
    end
  end

  post "/v1/zendesk/users/fetch" do
    before { stub_zendesk_all_user }

    let(:notify_email) { "homer.simpson@example.com" }
    let(:email) { open_last_email_for(notify_email) }

    parameter :notify_email, "Admin's email to notify"

    example_request "Create or update users from zendesk" do
      expect(status).to eq(201)
      expect(json_response_body).to have_key("job_id")
      expect(email).to have_subject("Users are imported")
    end
  end
end
