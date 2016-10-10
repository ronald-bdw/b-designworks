class GooglefitRequest < BaseRequest
  def initialize(options)
    @authorization_code = options[:authorization_code]
    @token = options[:token]
    @base_url = "https://www.googleapis.com"
    @token_path = "oauth2/v4/token"
    @activities_path = "/fitness/v1/users/me/dataSources"
  end

  def fetch_token
    GooglefitResponse.new(retrive_token.body)
  end

  def fetch_activities
    GooglefitResponse.new(retrive_activities.body)
  end

  private

  def prepare_header(req)
    req.url token_path
  end

  def request_body
    {
      grant_type: "authorization_code",
      client_id: ENV["GOOGLEFIT_CLIENT_ID"],
      code: authorization_code,
      redirect_uri: ENV["GOOGLEFIT_CALLBACK_URL"],
      client_secret: ENV["GOOGLEFIT_CLIENT_SECRET"]
    }
  end
end
