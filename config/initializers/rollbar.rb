require "rollbar/rails"

Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  config.enabled = !(Rails.env.test? || Rails.env.development?)

  # Ignoring 404 errors
  config.exception_level_filters.merge!("ActionController::RoutingError" => "ignore",
                                        "AbstractController::ActionNotFound" => "ignore")
end
