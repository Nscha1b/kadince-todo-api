require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @demo = users(:demo)
    @demo_headers = auth_headers_for_user(@demo)
  end

  test "unauthorized access to reports todo endpoint" do
    get "/todos/report/print", as: :json
    assert_response :unauthorized
  end

  test "authorized user can generate pdf report" do
    get "/todos/report/print", headers: @demo_headers
    assert_response :success

    assert_equal "application/pdf", response.content_type
    assert_includes response.headers["Content-Disposition"], "attachment"
    assert_includes response.headers["Content-Disposition"], "filename"
    assert_includes response.headers["Content-Disposition"], "todos_report.pdf"

    assert response.body.present?
    assert response.body.start_with?("%PDF")
  end

  private

  def auth_headers_for_user(user, password: "password")
    post "/auth/sign_in", params: { email: user.email, password: password }
    assert_response :success

    {
      "uid" => response.headers["uid"],
      "client" => response.headers["client"],
      "access-token" => response.headers["access-token"],
      "expiry" => response.headers["expiry"],
      "token-type" => "Bearer"
    }
  end
end
