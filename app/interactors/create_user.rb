class CreateUser
  include Interactor

  def call
    if user.save
      #CreateSubscription.call(user, plan_id)
    end
    context.user = user
  end

  private

  def user_params
    @user ||= User.new(user_params)
  end
end
