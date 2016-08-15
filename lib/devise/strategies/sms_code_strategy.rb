module Devise
  module Strategies
    class SmsCode < Base
      def authenticate!
        fail!(I18n.t("user.errors.phone_number")) && return if phone_number_invalid?

        if sms_code.valid?
          success!(user)
        else
          fail!(sms_code.errors.full_messages.first)
        end
      end

      def sms_code
        @sms_code ||= ::SmsCode.new(user.auth_phone_code, params[:sms_code])
      end

      def user
        @user ||= User.find_by(phone_number: params[:phone_number])
      end

      def phone_number_invalid?
        params[:phone_number].nil? || user.nil?
      end
    end
  end
end
