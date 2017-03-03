class RegistrationStatus
  attr_reader :user
  private :user

  def initialize(phone_number)
    @user = User.find_by(phone_number: phone_number)
  end

  def as_json(_options = nil)
    {
      phone_registered: phone_registered,
      provider: provider&.name,
      subscriber: provider&.subscriber || false
    }
  end

  private

  def phone_registered
    user.present?
  end

  def provider
    user&.provider
  end
end
