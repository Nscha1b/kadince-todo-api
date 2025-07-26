require "test_helper"

class TodoFilterTest < ActiveSupport::TestCase
  def setup
    @user = users(:demo)
    @todos = @user.todos
  end

  test "filters completed todos" do
    params = { "completed" => "true" }
    filtered = TodoFilter.new(@todos, params).call

    assert filtered.all?(&:completed), "Found only completed todos"
  end

  test "filters incomplete todos" do
    params = { "completed" => "false" }
    filtered = TodoFilter.new(@todos, params).call

    assert filtered.none?(&:completed), "Found only incomplete todos"
  end

  test "returns all todos if no filter" do
    filtered = TodoFilter.new(@todos, {}).call

    assert_equal @todos.count, filtered.count
  end
end
