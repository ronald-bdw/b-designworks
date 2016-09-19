require "rails_helper"

describe FitnessToken do
  subject { build :fitness_token }

  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:token) }
end
