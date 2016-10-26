FactoryGirl.define do
  factory :fitness_token do
    user
    token "MyString"
    source 1
    refresh_token "MyString"

    FitnessToken.sources.keys.each do |source|
      trait source.to_sym do
        source source
      end
    end
  end
end
