class ApplicationController < ActionController::API
  # Defining the authenticate method in the ApplicationController and setting it up as a before_action
  # secures every controller inheriting from it.
  # A request to any other controller will need a valid JWT to access those controllers
  before_action :authenticate

  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  private

  def authenticate
    # we create an authenticate method to decode JSON Web tokens that users send us.
    # If we can successfully verify the token, we return the User object that represents the
    # user making the request. We're mostly interested in the happy path here and will bypass a lot of checks.
    authorization_header = request.headers['Authorization']
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JsonWebToken.decode(token)

    User.find(decoded_token[:user_id])
  end

  def invalid_token
    render json: { invalid_token: 'invalid token' }
  end

  def decode_error
    render json: { decode_error: 'decode error' }
  end
end
