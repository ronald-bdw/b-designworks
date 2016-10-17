require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users notifications" do
  header "Accept", "application/json"

  let(:user) { create :user }

  before { setup_authentication_header(user) }

  post "/v1/users/notifications" do
    it_behaves_like(
      "a method that requires an authentication",
      "user",
      "create notification"
    )

    parameter :kind, "(string)[message_push] Kind of notification", scope: :notification

    let(:kind) { "message_push" }

    example_request "create notification" do
      expect(status).to eq 201
    end
  end

  delete "/v1/users/notifications/:kind" do
    it_behaves_like(
      "a method that requires an authentication",
      "user",
      "delete notifications"
    )

    parameter :kind, "(string)[message_push] Kind of notification"

    before do
      create :notification, user: user
    end

    example_request "delete notification", kind: "message_push" do
      expect(status).to eq 200
    end
  end
end
