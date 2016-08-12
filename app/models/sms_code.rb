class SmsCode
  include ActiveModel::Validations

  attr_reader :phone_code, :expire_at, :sms_code

  validate :sms_code, :check_sms_code, :check_expire_at

  def initialize(auth_phone_code, sms_code)
    @phone_code = auth_phone_code.phone_code
    @expire_at = auth_phone_code.expire_at
    @sms_code = sms_code
  end

  private

  def check_sms_code
    errors.add :sms_code, I18n.t("sms_code.invalid") if phone_code != sms_code
  end

  def check_expire_at
    errors.add :sms_code, I18n.t("sms_code.expired") if expire_at < Time.current
  end
end
