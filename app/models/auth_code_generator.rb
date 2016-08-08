class AuthCodeGenerator
  attr_accessor :phone_code, :expire_at

  def initialize
    self.phone_code = generate_phone_code
    self.expire_at = generate_expire_at
  end

  private

  def generate_phone_code
    "1234"
  end

  def generate_expire_at
    Time.zone.now + 10.minutes
  end
end
