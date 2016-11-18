class SendNotifier
  include Interactor

  delegate :phone_number, :message, to: :context

  FALLBACK_ERRORS = [21_612].freeze

  def call
    send_sms(from: ENV["TWILIO_SMS_FROM"], fallback: true)
  end

  private

  def send_sms(from:, fallback: false)
    client.messages.create(from: from, to: phone_number, body: message)
  rescue Twilio::REST::RequestError => e
    Rollbar.info(e.message)

    if fallback && FALLBACK_ERRORS.include?(e.code)
      send_sms(from: ENV["TWILIO_SMS_FROM_NUMBER"])
    else
      errors = { phone_number: [I18n.t("twilio.errors.phone_number")] }
      context.fail!(errors: errors)
    end
  end

  def client
    @client ||= Twilio::REST::Client.new
  end
end
