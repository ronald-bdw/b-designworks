class GenerateAuthPhoneCode
  include Interactor

  delegate :phone_number, :device_type, to: :context

  def call
    auth_phone_code.phone_code = generator.phone_code
    auth_phone_code.expire_at = generator.expire_at
    auth_phone_code.user_id = user&.id
    auth_phone_code.save

    context.auth_phone_code = auth_phone_code

    context.message = I18n.t(
      "auth_phone_code.phone_code.#{device_type}.verification",
      phone_code: auth_phone_code.phone_code
    )
  end

  private

  def user
    @user ||= User.find_by(phone_number: phone_number)
  end

  def auth_phone_code
    @auth_phone_code ||= user&.auth_phone_code || AuthPhoneCode.new
  end

  def generator
    @generator ||= AuthCodeGenerator.new
  end
end
