class GenerateAuthPhoneCode
  include Interactor

  delegate :params, to: :context

  def call
    auth_phone_code.phone_code = generator.phone_code
    auth_phone_code.expire_at = generator.expire_at
    auth_phone_code.save

    context.auth_phone_code = auth_phone_code
  end

  private

  def user
    @user ||= User.find_by(phone_number: params[:phone_number])
  end

  def auth_phone_code
    @auth_phone_code ||= (user && user.auth_phone_code) || AuthPhoneCode.new
  end

  def generator
    @generator ||= AuthCodeGenerator.new
  end
end
