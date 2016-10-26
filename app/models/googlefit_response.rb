class GooglefitResponse
  INVALID_REFRESH_TOKEN_ERROR_TYPE = "invalid_grant".freeze

  attr_reader :success, :body

  include ActiveModel::Validations

  validate :body, :check_response

  alias success? valid?

  def initialize(response)
    @body ||= JSON.parse response
  end

  def steps
    body["point"]
  end

  def access_token
    body["access_token"]
  end

  def refresh_token
    body["refresh_token"]
  end

  def invalid_refresh_token?
    body["error"] == INVALID_REFRESH_TOKEN_ERROR_TYPE
  end

  private

  def check_response
    return if body["error"].blank?

    Rollbar.info(body["error_description"])
    errors.add :body, "Something went wrong!"
  end
end
