class SendNotifier
  include Interactor

  delegate :phone_number, :message, to: :context

  def call
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV["TWILIO_SMS_FROM"],
      to: phone_number,
      body: message
    )
  rescue Twilio::REST::RequestError => e
    Rollbar.info(e.message)

    errors = { phone_number: [I18n.t("twilio.errors.phone_number")] }
    context.fail!(errors: errors)
  end
end
