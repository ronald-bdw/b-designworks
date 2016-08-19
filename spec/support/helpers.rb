module Helpers
  def setup_devise_mapping(mapping_name = :user)
    @request.env["devise.mapping"] = Devise.mappings[mapping_name]
  end

  def json_response_body
    parse_json(response_body)
  end

  def setup_authentication_header(user)
    header("X-User-Token", user.authentication_token)
    header("X-User-Phone-Number", user.phone_number)
  end
end
