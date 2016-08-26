class SendPhoneCode
  include Interactor::Organizer

  organize GenerateAuthPhoneCode, SendNotifier
end
