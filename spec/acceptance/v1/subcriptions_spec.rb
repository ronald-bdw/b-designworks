require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Subcriptions" do
  header "Accept", "application/json"

  let!(:user) { create(:user) }
  let(:expires_at) { Time.current + 10.minutes }

  before do
    setup_authentication_header(user)
  end

  post "/v1/subscriptions" do
    subject(:response) { json_response_body }

    with_options required: true do |required|
      required.parameter :plan_name,
        "(string)[trial|habit_starter|habit_stabliser|habit_master] Plan name of subscription"
      required.parameter :expires_at, "(string) The expires_at of subscription"
      required.parameter :active, "(boolean) The status of subscription"
    end

    context "with valid params" do
      let(:params) do
        {
          plan_name: "habit_starter",
          expires_at: expires_at,
          active: false
        }
      end

      example_request "Save user subscription" do
        user.reload
        expect(response_status).to eq 201
        expect(user.subscription.plan_name).to eq "habit_starter"
      end
    end

    context "with invalid params", document: false do
      let(:params) { { expires_at: expires_at, active: false } }

      example_request "Can't save user subscription" do
        expect(response_status).to eq 422
        error = { "plan_name" => ["can't be blank", "is not included in the list"] }.deep_stringify_keys
        expect(response["error"]["validations"]).to eq(error)
      end
    end

    context "with exists subscription", document: false do
      let!(:subscription) { create :subscription, user: user }
      let(:params) do
        {
          plan_name: "habit_starter",
          expires_at: expires_at
        }
      end

      example_request "update user subscription" do
        user.reload
        expect(response_status).to eq 201
        expect(user.subscription.plan_name).to eq "habit_starter"
      end
    end
  end

  patch "/v1/subscriptions/expire" do
    context "when user has subscription" do
      let!(:subscription) { create :subscription, user: user, active: true }

      example_request "Expire subscription" do
        expect(status).to eq 200
        expect(subscription.reload).to_not be_active
      end
    end

    context "when user doesn't have subscription", document: false do
      example_request "Expire subscription" do
        expect(status).to eq 404
      end
    end
  end
end
