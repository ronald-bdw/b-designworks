require "rails_helper"

describe Users::CreateFromFile do
  describe ".call" do
    subject(:interactor) { described_class.call(file: file) }

    after do
      file.close
    end

    context "with valid xlsx file" do
      let(:file) { File.open("spec/fixtures/files/valid_users_collection.xlsx") }

      it "creates users" do
        expect { interactor }.to change { User.count }.from(0).to(1)
      end

      it "creates users under default provider" do
        expect(interactor).to be_success
        expect(User.last.provider.name).to eq(Provider::DEFAULT_PROVIDER_NAME)
      end
    end

    context "with invalid xlsx file" do
      let(:file) { File.open("spec/fixtures/files/invalid_users_collection.xlsx") }

      it "does not create users" do
        expect { interactor }.not_to change { User.count }
      end

      it "stores invalid users" do
        expect(interactor).not_to be_success
        expect(interactor.invalid_users.size).to eq(1)
      end
    end
  end
end
