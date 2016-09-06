module ZendeskAuthorizer
  def authorize_zendesk_app!
    return if valid_headers?

    render json: RailsApiFormat::Error.new(
      status: :unauthorized,
      error: I18n.t("zendesk.errors.not_authorized_token")
    ), status: :unauthorized
  end

  def valid_headers?
    request.headers["X-Auth-Token"].present? &&
      request.headers["X-Auth-Token"] == ZENDESK_PEARUP_API_TOKEN
  end
end
