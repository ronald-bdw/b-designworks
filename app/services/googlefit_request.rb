class GooglefitRequest < BaseRequest
  attr_reader :start_date, :end_date
  private :start_date, :end_date

  def initialize(options)
    @authorization_code = options[:authorization_code]
    @token = options[:token]
    @base_url = "https://www.googleapis.com"
    @token_path = "oauth2/v4/token"
    @start_date = options[:start_date]
    @end_date = options[:end_date]
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
    "#{start_date.to_i}000000000-#{end_date.to_i}000000000"
  end
end
