require "test_helper"

class DemosControllerTest < ActionDispatch::IntegrationTest
  test "should log in and return auth headers" do
    post "/demo_login"
    assert_response :success
    json = JSON.parse(response.body)
    user = users(:demo)

    assert_equal user[:email], json["data"]["email"]
    assert_equal user[:name], json["data"]["name"]

    assert response.headers["access-token"]
    assert response.headers["uid"]
    assert response.headers["client"]
  end

  test "should reuse existing demo user" do
    user = users(:demo)

    post "/demo_login"

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal user.id, json["data"]["id"]
    assert_equal user[:email], json["data"]["email"]
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
end
