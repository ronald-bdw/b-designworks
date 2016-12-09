source "https://rubygems.org"

ruby "2.3.1"

# the most important stuff
gem "rails", "4.2.7.1"
gem "pg"
gem "rails-api"
gem "rails_api_format", path: "lib/rails_api_format"

# all other gems
gem "active_model_serializers", git: "https://github.com/rails-api/active_model_serializers.git"
gem "carrierwave"
gem "decent_exposure"
gem "delayed_job_active_record"
gem "devise"
gem "dotenv-rails"
gem "faraday"
gem "fog-aws"
gem "groupdate"
gem "interactor"
gem "kaminari"
gem "mini_magick"
gem "phonelib"
gem "rack-cors", require: "rack/cors"
gem "responders"
gem "rollbar"
gem "rubyXL"
gem "seedbank"
gem "simple_token_authentication"
gem "thin"
gem "twilio-ruby", "~> 4.11.1"
gem "zendesk_api"

group :development do
  gem "capistrano"
  gem "capistrano3-puma", require: false
  gem "capistrano3-delayed-job", require: false
  gem "capistrano-rails", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rbenv", require: false
  gem "mail_safe"
  gem "bullet"
  gem "foreman"
  gem "letter_opener"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "pry-rails"
  gem "brakeman"
  gem "bundler-audit"
  gem "byebug"
  gem "rspec-rails"
  gem "rubocop"
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem "database_cleaner"
  gem "email_spec"
  gem "json_spec"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "vcr", require: false
  gem "webmock", require: false
end

group :development, :test, :staging do
  gem "faker"
  gem "factory_girl_rails"
  gem "rspec_api_documentation"
  gem "apitome"
end

group :staging, :production do
  gem "rails_12factor"
end
