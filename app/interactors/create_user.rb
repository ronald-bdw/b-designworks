class CreateUser
  include Interactor

  delegate :user_params, :auth_phone_code, :sms_auth_code, to: :context

  def call
    create_user

    context.user = user
  end

  private

  def create_user
    if sms_code.valid?
      user.auth_phone_code = auth_phone_code
      user.save
    else
      user.errors.messages.merge!(sms_code.errors.messages)
    end
  end

  def user
    @user ||= User.new(user_params)
  end

  def sms_code
    @sms_code ||= SmsCode.new(auth_phone_code, sms_auth_code)
  end
end
