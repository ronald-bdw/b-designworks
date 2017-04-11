class AndroidSubscriptionExpirationUsers
  attr_reader :expires_at
  private :expires_at

  def initialize(expires_at)
    @expires_at = expires_at
  end

  def all
    User
      .includes(:subscription)
      .where.not(subscriptions: { id: nil, active: false })
      .where(device: "android", subscriptions: { expires_at: expires_at })
  end
end
