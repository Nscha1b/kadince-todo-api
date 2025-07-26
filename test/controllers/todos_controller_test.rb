require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @todo = todos(:one)
    @uncompleted_todo = todos(:three)
    @not_demos_todo = todos(:two)
    @demo = users(:demo)
    @demo_headers = auth_headers_for_user(users(:demo))
  end

  test "unauthorized access to todos routes" do
    get todos_url, as: :json
    assert_response :unauthorized

    post todos_url, params: { todo: { title: "Test" } }, as: :json
    assert_response :unauthorized

    todo = todos(:one)

    patch todo_url(todo), as: :json
    assert_response :unauthorized

    put todo_url(todo), as: :json
    assert_response :unauthorized

    delete todo_url(todo), as: :json
    assert_response :unauthorized
  end

  class Index < TodosControllerTest
    test "should get users todos" do
      get todos_url, as: :json, headers: @demo_headers
      assert_response :success
    end

    test "can get only completed todos" do
      get "#{todos_url}?completed=true", headers: @demo_headers, as: :json
      assert_response :success

      data = JSON.parse(response.body)
      found = data.any? { |todo| todo["id"] == @todo.id }
      uncompleted_exists = data.any? { |todo| todo["id"] == @uncompleted_todo.id }

      assert found, "Expected todo with id #{@todo.id} to be in the response"
      assert_not uncompleted_exists, "Expected todo with id #{@uncompleted_todo.id} NOT to be in the response"
    end

    test "can get only items todo" do
      get "#{todos_url}?completed=false", headers: @demo_headers, as: :json
      assert_response :success

      data = JSON.parse(response.body)
      found = data.any? { |todo| todo["id"] == @todo.id }
      uncompleted_exists = data.any? { |todo| todo["id"] == @uncompleted_todo.id }

      assert_not found, "Expected todo with id #{@todo.id} NOT to be in the response"
      assert uncompleted_exists, "Expected todo with id #{@uncompleted_todo.id} to be in the response"
    end

    test "should not get other users todos" do
      get todos_url, as: :json, headers: @demo_headers

      data = JSON.parse(response.body)
      found = data.any? { |todo| todo["id"] == @not_demos_todo.id }

      assert_not found, "Expected todo with id #{@not_demos_todo.id} NOT to be in the response"
    end
  end

  class Create < TodosControllerTest
    test "should create todo" do
      title = "title123"
      assert_difference("Todo.count") do
        post todos_url, params: { todo: { title: title } }, as: :json, headers: @demo_headers
      end

      assert_response :created

      data = JSON.parse(response.body)
      assert_equal title, data["title"]
    end

    test "Should not save without a title" do
      post todos_url, params: { todo: { title: nil, description: "desc" } }, as: :json, headers: @demo_headers
      assert_response :unprocessable_entity
    end
  end

  class Update < TodosControllerTest
    test "should update todo" do
      new_title = "new_title"
      patch todo_url(@todo), params: { todo: { title: new_title } }, as: :json, headers: @demo_headers
      assert_response :success
      @todo.reload
      assert_equal @todo[:title], new_title
    end

    test "can complete a todo" do
      put todo_url(@uncompleted_todo), params: { todo: { completed: true } }, as: :json, headers: @demo_headers
      assert_response :success
      @uncompleted_todo.reload
      assert_equal @uncompleted_todo[:completed], true
    end

    test "invalid update should fail" do
      patch todo_url(@todo), params: { todo: { title: nil } }, as: :json, headers: @demo_headers
      assert_response :unprocessable_entity
    end

    test "returns not found whe record doesn't exist" do
      patch todo_url(9999999_9999999), params: { todo: { title: nil } }, as: :json, headers: @demo_headers
      assert_response :not_found
    end

    test "cant update another users todo" do
      put todo_url(@not_demos_todo), params: { todo: { completed: true } }, as: :json, headers: @demo_headers
      assert_response :not_found
    end
  end

  class Destroy < TodosControllerTest
    test "should destroy todo" do
      assert_difference("Todo.count", -1) do
        delete todo_url(@todo), as: :json, headers: @demo_headers
      end

      assert_response :no_content
      assert_raises(ActiveRecord::RecordNotFound) do
        @todo.reload
      end
    end

    test "returns not found whe record doesn't exist" do
      delete todo_url(999999_99999), as: :json, headers: @demo_headers
      assert_response :not_found
    end

    test "cant delete another users todo" do
      delete todo_url(@not_demos_todo), as: :json, headers: @demo_headers
      assert_response :not_found
    end
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
