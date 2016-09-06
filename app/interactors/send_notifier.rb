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
    errors = { message: [e.message] }
    context.fail!(errors: errors)
  end
end
