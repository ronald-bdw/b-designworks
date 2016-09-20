module FitnessTokens
  class FitbitRequest
    include Interactor

    delegate :authorization_code, :device_type, to: :context

    def call
      if parsed_body["errors"].present?
        Rollbar.info(parsed_body["errors"][0]["message"])
        context.fail!(errors: "is invalid")
      end

      context.response = parsed_body
    end

    private

    def parsed_body
      @body ||= JSON.parse fetch_token.body
    end

    def fetch_token
      conn.post do |req|
        req.url ENV["FITBIT_TOKEN_PATH"]
        setup_headers(req)
        req.body = {
          grant_type: "authorization_code",
          client_id: ENV["FITBIT_CLIENT_ID"],
          code: authorization_code,
          redirect_uri: redirect_url
        }
      end
    end

    def conn
      Faraday.new(url: ENV["FITBIT_API_URL"]) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def redirect_url
      if device_type =~ /android/
        ENV["ANDROID_REDIRECT_URL"]
      elsif device_type =~ /iphone/
        ENV["IOS_REDIRECT_URL"]
      else
        ""
      end
    end

    def auth_token
      encoded_secret = Base64.encode64("#{ENV['FITBIT_CLIENT_ID']}:#{ENV['FITBIT_CLIENT_SECRET']}")
      "Basic #{encoded_secret}"
    end

    def setup_headers(request)
      request.headers["Content-Type"] = "application/x-www-form-urlencoded"
      request.headers["Authorization"] = auth_token
    end
  end
end
