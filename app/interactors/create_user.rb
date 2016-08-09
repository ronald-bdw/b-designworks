class CreateUser
  include Interactor

  delegate :user_params, :auth_phone_code, :sms_auth_code, to: :context

  def call
    context.fail!(errors: sms_code.errors.messages) if sms_code.invalid?

    user.save
    context.user = user
  end

  private

  def user
    @user ||= User.new(user_params)
  end

  def sms_code
    @sms_code ||= SmsCode.new(auth_phone_code.try(:phone_code), sms_auth_code)
  end
end
