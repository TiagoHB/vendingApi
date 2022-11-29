module ApiHelpers
  def json
    JSON.parse(response.body)
  end

  def get_headers(login)
    jwt = get_jwt(login)
    {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': "Bearer #{jwt}"
    }
  end

  def get_jwt(login)
    post '/users/sign_in', params: { user: { username: login, password: '111111' } }
    JSON.parse(response.body, object_class: OpenStruct).jwt
  end
end