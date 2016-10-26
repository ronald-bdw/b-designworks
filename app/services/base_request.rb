class BaseRequest
  attr_reader :access_token,
    :refresh_token,
    :authorization_code,
    :started_at,
    :finished_at,
    :base_url,
    :auth_path,
    :steps_path

  def initialize(options = {})
    @fitness_token = options[:fitness_token]

    if @fitness_token.present?
      @access_token = @fitness_token.token
      @refresh_token = @fitness_token.refresh_token
    end

    @authorization_code = options[:authorization_code]
    @started_at = options[:started_at]
    @finished_at = options[:finished_at]
  end

  private

  def retrive_token
    faraday_client.post do |req|
      prepare_auth_headers(req)
      req.body = auth_request_body
    end
  end

  def retrive_refresh_token
    faraday_client.post do |req|
      prepare_auth_headers(req)
      req.body = refresh_token_body
    end
  end

  def retrive_steps
    faraday_client.get do |req|
      req.url(steps_path)
      setup_headers(
        req,
        "Bearer #{access_token}",
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
