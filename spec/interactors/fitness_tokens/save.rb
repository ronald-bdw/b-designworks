require "rails_helper"

describe FitnessTokens::Save do
  describe ".call" do
    subject(:interactor) do
      described_class.call(
        fitness_token: fitness_token,
        fitbit_access_token: fitbit_access_token,
        fitbit_refresh_token: fitbit_refresh_token
      )
    end

    before { subject }

    context "with valid params" do
      context "with fitbit in source params" do
        let(:fitness_token) do
          build(
            :fitness_token,
            source: "fitbit",
            authorization_code: "auth code from fitbit"
          )
        end

        let(:fitbit_access_token) { "access_token_from_fitbit" }
        let(:fitbit_refresh_token) { "refresh_token_from_fitbit" }

        it "save token and refresh_token" do
          expect(fitness_token.token).to eq fitbit_access_token
          expect(fitness_token.refresh_token).to eq fitbit_refresh_token
        end
      end

      context "with googlefit in source params" do
        let(:fitness_token) do
          build(
            :fitness_token,
            source: "googlefit",
            token: "token from googlefit",
            refresh_token: nil
          )
        end

        let(:fitbit_access_token) { nil }
        let(:fitbit_refresh_token) { nil }

        it "save token" do
          expect(fitness_token.token).to eq "token from googlefit"
          expect(fitness_token.refresh_token).to be_nil
        end
      end
    end

    context "with invalid params" do
      let(:fitness_token) do
        build(
          :fitness_token,
          source: "fitbit",
          token: nil,
          refresh_token: nil
        )
      end

      let(:fitbit_access_token) { nil }
      let(:fitbit_refresh_token) { nil }

      it "does not save token and refresh token and return error" do
        expect(fitness_token.token).to be_nil
        expect(fitness_token.refresh_token).to be_nil
        expect(fitness_token.errors.full_messages).to eq ["Token can't be blank"]
      end
    end
  end
end
