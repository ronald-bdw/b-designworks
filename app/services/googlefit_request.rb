class GooglefitRequest < BaseRequest
  attr_reader :started_at, :finished_at

  DATA_SOURCE_ID = "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps".freeze

  def initialize(options = {})
    super

    @base_url = "https://www.googleapis.com"
    @auth_path = "oauth2/v4/token"
    @started_at = options[:started_at]
    @finished_at = options[:finished_at]
    @steps_path = "/fitness/v1/users/me/dataSources/#{DATA_SOURCE_ID}/datasets/#{date_range}"
  end

  def fetch_token
    GooglefitResponse.new(retrive_token.body)
  end

  def fetch_activities
    GooglefitResponse.new(retrive_steps.body)
  end

  def refresh_access_token
    GooglefitResponse.new(retrive_refresh_token.body)
  end

  private

  def prepare_auth_headers(req)
    req.url(auth_path)
  end

  def refresh_token_body
    {
      grant_type: "refresh_token",
      refresh_token: refresh_token,
      client_id: ENV["GOOGLEFIT_CLIENT_ID"],
      redirect_uri: ENV["GOOGLEFIT_CALLBACK_URL"],
      client_secret: ENV["GOOGLEFIT_CLIENT_SECRET"]
    }
  end

  def auth_request_body
    {
      grant_type: "authorization_code",
      client_id: ENV["GOOGLEFIT_CLIENT_ID"],
      code: authorization_code,
      redirect_uri: ENV["GOOGLEFIT_CALLBACK_URL"],
      client_secret: ENV["GOOGLEFIT_CLIENT_SECRET"]
    }
  end

  def date_range
    "#{started_at.to_i}000000000-#{finished_at.to_i}000000000"
  end
end
