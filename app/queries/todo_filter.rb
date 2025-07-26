class TodoFilter
  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def call
    filtered = @scope
    filter_by_completed(filtered)
  end

  private
  def filter_by_completed(scope)
    return scope unless @params["completed"].present?

    completed = ActiveModel::Type::Boolean.new.cast(@params["completed"])
    if completed
      scope.completed
    else
      scope.incomplete
    end
  end
end
