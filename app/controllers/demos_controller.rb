class DemosController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  def demo_login
    user = find_or_create_demo_user

    token = user.create_new_auth_token

    if token.present? && token["access-token"]
      response.headers.merge!(token)
      render json: { data: user }, status: :ok
    else
      render json: { error: "Demo authentication token generation failed." }, status: :unauthorized
    end

    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      render_error("Failed to create demo user: #{e.message}", :unprocessable_entity)
    rescue StandardError => e
      render_error("Unexpected error: #{e.message}", :internal_server_error)
    end
end

private

def find_or_create_demo_user
  user = User.find_or_create_by!(email: demo_details[:email]) do |u|
    u.password = SecureRandom.hex(10)
    u.password_confirmation = u.password
    u.name = demo_details[:name]
  end
end

def demo_details
  {
    email: "demo@example.com",
    name: "Demo User"
  }.freeze
end
