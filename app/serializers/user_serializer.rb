class UserSerializer < ApplicationSerializer
  attributes :id, :phone_number, :authentication_token, :email
end
