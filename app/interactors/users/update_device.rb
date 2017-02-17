module Users
  class UpdateDevice
    include Interactor

    delegate :user, :device, to: :context

    def call
      user.update(device: device) if device.present?
    end
  end
end
