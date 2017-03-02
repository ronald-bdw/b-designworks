require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Providers" do
  header "Accept", "application/json"

  subject(:response) { json_response_body }

  let!(:subscriber_providers) { create_list(:provider, 2, subscriber: true) }

  before do
    create_list(:provider, 3)
  end

  get "/v1/providers" do
    example_request "Get providers list" do
      expect(response_status).to eq 200
      expect(response["providers"].size).to eq(3)
      expect(response["providers"]).to_not include ProviderSerializer.new(subscriber_providers.first).as_json
    end
  end
end
