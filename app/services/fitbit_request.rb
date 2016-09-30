class FitbitRequest
  attr_reader :token, :authorization_code

  TOKEN_PATH = "/oauth2/token".freeze
  ACTIVITIES_PATH = "1/user/-/activities/steps/date/today/1d.json".freeze

  def initialize(options)
    @token = options[:token]
    @authorization_code = options[:authorization_code]
  end

  def fetch_token
    response = faraday_client.post do |req|
      req.url TOKEN_PATH
      setup_headers(
        req,
        auth_fetch_token,
        "application/x-www-form-urlencoded"
      )
      req.body = {
        grant_type: "authorization_code",
        client_id: ENV["FITBIT_CLIENT_ID"],
        code: authorization_code,
        redirect_uri: ENV["FITBIT_CALLBACK_URL"]
      }
    end

    FitbitResponse.new(response.body)
  end

  def fetch_activities
    response = faraday_client.get do |req|
      req.url ACTIVITIES_PATH
      setup_headers(
        req,
        "Bearer #{token}",
        "application/json"
      )
    end

    FitbitResponse.new(response.body)
  end

  private

  def faraday_client
    @client ||= Faraday.new(url: "https://api.fitbit.com") do |config|
      config.request :url_encoded
      config.response :logger
      config.adapter Faraday.default_adapter
    end
  end

  def auth_fetch_token
    encoded_secret = Base64.encode64("#{ENV['FITBIT_CLIENT_ID']}:#{ENV['FITBIT_CLIENT_SECRET']}")
    "Basic #{encoded_secret}"
  end

  def setup_headers(request, auth_token, type)
    request.headers["Content-Type"] = type
    request.headers["Authorization"] = auth_token
  end
end
