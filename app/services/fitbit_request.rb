class FitbitRequest < BaseRequest
  def initialize(options = {})
    super

    @base_url = "https://api.fitbit.com"
    @auth_path = "/oauth2/token"
    @steps_path = "1/user/-/activities/steps/date/today/#{period}.json"
  end

  def fetch_token
    FitbitResponse.new(retrive_token.body)
  end

  def fetch_activities
    FitbitResponse.new(retrive_steps.body)
  end

  def refresh_access_token
    FitbitResponse.new(retrive_refresh_token.body)
  end

  private

  def period
    return "1d" unless started_at && finished_at

    started_at.to_date == finished_at.to_date ? "1d" : "7d"
  end

  def prepare_auth_headers(req)
    req.url(auth_path)
    setup_headers(
      req,
      "Basic #{encoded_secret}",
      "application/x-www-form-urlencoded"
    )
  end

  def refresh_token_body
    {
      grant_type: "refresh_token",
      refresh_token: refresh_token
    }
  end

  def auth_request_body
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
