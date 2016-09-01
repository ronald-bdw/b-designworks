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
  rescue => e
    context.fail!(error: e.message)
  end
end
