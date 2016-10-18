require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Users notifications" do
  header "Accept", "application/json"

  let(:user) { create :user }

  before { setup_authentication_header(user) }

  post "/v1/notifications" do
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

    context "when message push notification exists", document: false do
      before { create :notification, user: user }

      example_request "Enable notification" do
        expect(status).to eq 422
      end
    end
  end

  delete "/v1/notifications/:kind" do
    it_behaves_like(
      "a method that requires an authentication",
      "user",
      "delete notifications"
    )

    parameter :kind, "(string)[message_push] Kind of notification"

    before { create :notification, user: user }

    example_request "Disable notification", kind: "message_push" do
      expect(status).to eq 200
    end
  end
end
