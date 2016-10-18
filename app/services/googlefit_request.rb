class GooglefitRequest < BaseRequest
  attr_reader :started_at, :finished_at
  private :started_at, :finished_at

  def initialize(options)
    @authorization_code = options[:authorization_code]
    @token = options[:token]
    @base_url = "https://www.googleapis.com"
    @token_path = "oauth2/v4/token"
    @started_at = options[:started_at]
    @finished_at = options[:finished_at]
    data_source_id = "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
    @activities_path = "/fitness/v1/users/me/dataSources/#{data_source_id}/datasets/#{date_range}"
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

  def date_range
    "#{started_at.to_i}000000000-#{finished_at.to_i}000000000"
  end
end
