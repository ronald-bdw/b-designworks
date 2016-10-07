class BaseRequest
  attr_reader :token, :authorization_code, :base_url, :token_path, :activities_path
  private :base_url, :token_path, :activities_path

  private

  def retrive_token
    faraday_client.post do |req|
      req.url token_path
      setup_headers(
        req,
        "Basic #{encoded_secret}",
        "application/x-www-form-urlencoded"
      )
      req.body = request_body
    end
  end

  def retrive_activities
    faraday_client.get do |req|
      req.url activities_path
      setup_headers(
        req,
        "Bearer #{token}",
        "application/json"
      )
    end
  end

  def faraday_client
    @client ||= Faraday.new(url: base_url) do |config|
      config.request :url_encoded
      config.response :logger
      config.adapter Faraday.default_adapter
    end
  end

  def setup_headers(request, auth_token, type)
    request.headers["Content-Type"] = type
    request.headers["Authorization"] = auth_token
  end
end
