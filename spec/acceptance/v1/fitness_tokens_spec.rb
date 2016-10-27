require "rails_helper"
require "rspec_api_documentation/dsl"

resource "FitnessTokens" do
  header "Accept", "application/json"

  let!(:user) { create(:user) }
  let(:date) { Time.zone.parse("2016-01-01 10:00:00") }

  before do
    setup_authentication_header(user)
    allow(Time).to receive(:current).and_return(date)
    allow(FetchActivitiesJob).to receive(:perform_later).and_return(true)
  end

  post "/v1/fitness_tokens" do
    let(:user_id) { user.id }

    subject(:response) { json_response_body }

    with_options required: true do |required|
      required.parameter :source, "(string)[googlefit|fitbit] Source of fitness token"
      required.parameter :authorization_code, "(string) The authorization code"
    end

    context "with valid params" do
      context "for fitbit integration" do
        let(:params) do
          {
            authorization_code: "my token",
            source: "fitbit"
          }
        end

        example_request "Save user fitness token" do
          fitness_token = user.fitness_tokens.last
          expect(response_status).to eq 201
          expect(fitness_token.token).to eq "access_token_from_fitbit"
          expect(fitness_token.refresh_token).to eq "refresh_token_from_fitbit"
        end
      end

      context "for googlefit integration", document: false do
        let(:params) do
          {
            authorization_code: "my token",
            source: "googlefit"
          }
        end

        example_request "Save user fitness token" do
          fitness_token = user.fitness_tokens.last

          expect(response_status).to eq 201
          expect(fitness_token.token).to eq "access_token_from_googlefit"
          expect(fitness_token.refresh_token).to eq "refresh_token_from_googlefit"
        end
      end
    end

    context "with invalid params", document: false do
      let(:params) { { source: "fitbit" } }

      example_request "Can't save user fitness token" do
        expect(response_status).to eq 422
        error = { token: [{ body: ["Something went wrong!"] }] }.deep_stringify_keys
        expect(response["error"]["validations"]).to eq(error)
      end
    end
  end

  delete "/v1/fitness_tokens/:id" do
    it_behaves_like(
      "a method that requires an authentication",
      "fitness_token",
      "deleting"
    )

    parameter :id, "Fitness token id", required: true

    let(:fitness_token) { create :fitness_token, user: user }
    let(:id) { fitness_token.id }

    example_request "Delete fitness token" do
      expect(status).to eq(200)
    end

    context "when fitness token does not exist", document: false do
      let(:id) { "99999" }

      example_request "Deleting not existed fitness token" do
        expect(status).to eq(404)
      end
    end
  end
end
