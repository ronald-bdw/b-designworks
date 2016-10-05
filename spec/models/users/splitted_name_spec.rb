require "rails_helper"

describe Users::SplittedName do
  let(:splitted_name) { described_class.new(full_name) }

  context "with one-word name" do
    let(:full_name) { "Homer" }

    describe "#first_name" do
      subject { splitted_name.first_name }

      it { is_expected.to eq("Homer") }
    end

    describe "#last_name" do
      subject { splitted_name.last_name }

      it { is_expected.to be_nil }
    end

    describe "#to_hash" do
      subject { splitted_name.to_hash }

      it { is_expected.to eq(first_name: "Homer", last_name: nil) }
    end
  end

  context "with two-word name" do
    let(:full_name) { "Homer Simpson" }

    describe "#first_name" do
      subject { splitted_name.first_name }

      it { is_expected.to eq("Homer") }
    end

    describe "#last_name" do
      subject { splitted_name.last_name }

      it { is_expected.to eq("Simpson") }
    end

    describe "#to_hash" do
      subject { splitted_name.to_hash }

      it { is_expected.to eq(first_name: "Homer", last_name: "Simpson") }
    end
  end
end
