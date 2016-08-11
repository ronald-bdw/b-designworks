class CreateUser
  include Interactor

  delegate :user_params, :auth_phone_code, :sms_auth_code, to: :context

  def call
    if sms_code.valid?
      user.save
    else
      user.errors.messages.merge!(sms_code.errors.messages)
    end

    context.user = user
  end

  private

  def user
    @user ||= User.new(user_params)
  end

  def sms_code
    @sms_code ||= SmsCode.new(auth_phone_code, sms_auth_code)
  end
end
