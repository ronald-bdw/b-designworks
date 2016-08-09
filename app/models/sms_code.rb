class SmsCode
  include ActiveModel::Validations

  attr_accessor :phone_code, :sms_code

  validate :phone_code, :check_sms_code

  def initialize(phone_code, sms_code)
    @phone_code = phone_code
    @sms_code = sms_code
  end

  def check_sms_code
    errors.add :phone_code, I18n.t("sms_code.invalid") unless phone_code == sms_code
  end
end
