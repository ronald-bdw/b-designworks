class FitbitRequest < BaseRequest
  def initialize(options)
    @authorization_code = options[:authorization_code]
    @token = options[:token]
    @base_url = "https://api.fitbit.com"
    @token_path = "/oauth2/token"
    @activities_path = "1/user/-/activities/steps/date/today/1d.json"
  end

  def fetch_token
    FitbitResponse.new(retrive_token.body)
  end

  def fetch_activities
    FitbitResponse.new(retrive_activities.body)
  end

  private

  def prepare_header(req)
    req.url token_path
    setup_headers(
      req,
      "Basic #{encoded_secret}",
      "application/x-www-form-urlencoded"
    )
  end

  def request_body
    {
      grant_type: "authorization_code",
      client_id: ENV["FITBIT_CLIENT_ID"],
      code: authorization_code,
      redirect_uri: ENV["FITBIT_CALLBACK_URL"]
    }
  end

  def encoded_secret
    Base64.encode64("#{ENV['FITBIT_CLIENT_ID']}:#{ENV['FITBIT_CLIENT_SECRET']}")
  end
end
