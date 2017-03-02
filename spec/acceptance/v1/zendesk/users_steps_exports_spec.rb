require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Zendesk User steps export" do
  include_context "zendesk app"
  header "Accept", "application/json"

  let(:aws_upload) { double file: "aws_file_url" }

  before do
    allow(Users::AwsUploader).to receive(:call).and_return(aws_upload)
  end

  post "/v1/zendesk/users_steps_exports" do
    parameter :provider_name, "Provider name"

    let(:params) { { organization_id: provider.zendesk_id } }

    let!(:user) { create :user, provider: provider }
    let!(:provider) { create :provider }

    example_request "Export users steps" do
      expect(status).to eq(200)
    end
  end
end
