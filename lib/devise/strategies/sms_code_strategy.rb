module Devise
  module Strategies
    class SmsCode < Base
      def valid?
        params[:phone_number] && params[:sms_code]
      end

      def authenticate!
        fail!("Phone number is not valid") && return if user.nil?

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
    end
  end
end
