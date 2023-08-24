class AuthenticationController < ApplicationController
  # When a request hits this controller, because it's a user asking for a token,
  # we don't want to initially authenticate them. The purpose of this controller is
  # to respond with a token the user can use to access the rest of the resources on our server.
  # Hence the need for skip_before_action :authenticate on the second line.
  skip_before_action :authenticate

  def login
    # In the login action (the one that users hit for a token),
    # we grab the username and password from the parameters that come with the request to this controller.
    # If we can authenticate the user — that is, verify if their username and password match
    # what we have stored in our database — then we present them with a signed token and
    # information about when that token expires.
    user = User.find_by(username: params[:username])
    authenticated_user = user&.authenticate(params[:password])

    if authenticated_user
      token = JsonWebToken.encode(user_id: user.id)
      expires_at = JsonWebToken.decode(token)[:exp]

      render json: { token: token, expires_at: expires_at}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
