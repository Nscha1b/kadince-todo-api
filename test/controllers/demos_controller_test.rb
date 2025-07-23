require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should log in and return auth headers" do
    User.where(email: demo_details[:email]).destroy_all
    post "/demo_login"
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal demo_details[:email], json["data"]["email"]
    assert_equal demo_details[:name], json["data"]["name"]

    assert response.headers["access-token"]
    assert response.headers["uid"]
    assert response.headers["client"]
  end

  test "should reuse existing demo user" do
    user = User.create!(
      email: demo_details[:email],
      name: demo_details[:name],
      password: "testpassword",
      password_confirmation: "testpassword"
    )

    post "/demo_login"

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal user.id, json["data"]["id"]
    assert_equal demo_details[:email], json["data"]["email"]
  end

  test "returns 500 when unexpected error occurs" do
    User.expects(:find_or_create_by!).raises(StandardError.new("Something went wrong"))

    post demo_login_url

    assert_response :internal_server_error
    body = JSON.parse(response.body)
    assert_match /Unexpected error/, body["error"]
  end

  test "returns 422 when record is invalid" do
    User.expects(:find_or_create_by!).raises(ActiveRecord::RecordInvalid.new(User.new))

    post demo_login_url

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)
    assert_match /Failed to create demo user/, body["error"]
  end

  private

  def demo_details
    {
      email: "demo@example.com",
      name: "Demo User"
    }
  end
end
