FactoryGirl.define do
  factory :fitness_token do
    user
    token "MyString"
    source 1
    refresh_token "MyString"
  end
end
