require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Notification subscribers" do
  include_context "zendesk app"
  header "Accept", "application/json"

  post "/v1/zendesk/notification_subscribers" do
    parameter :email, "Subscriber's email"
    parameter :notification_types, "(array)[first_user_login] Subscriber's notification types"

    let(:attributes) { attributes_for(:notification_subscriber) }
    let(:email) { attributes[:email] }
    let(:notification_types) { attributes[:notification_types] }

    example_request "Create notification subscriber" do
      expect(status).to eq(201)
    end
  end
end
