require "zendesk_api"

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = ENV["ZENDESK_URL"]

  config.username = ENV["ZENDESK_USERNAME"]
  config.token = ENV["ZENDESK_TOKEN"]

  # Optional:

  # Retry uses middleware to notify the user
  # when hitting the rate limit, sleep automatically,
  # then retry the request.
  config.retry = true

  # Logger prints to STDERR by default, to e.g. print to stdout:
  require "logger"
  config.logger = Logger.new(STDOUT)

  # Changes Faraday adapter
  # config.adapter = :patron

  # Merged with the default client options hash
  # config.client_options = { :ssl => false }
end
