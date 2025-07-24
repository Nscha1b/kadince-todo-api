class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[ update destroy ]
  # STILL NEED TO HANDLE EDITs!
  # Still need to handle deleetes
  # still need to handle filtering...
  # Still need to handle completing a todo

  # GET /todos
  def index
    @todos = current_user.todos

    render json: @todos
  end

  # POST /todos
  def create
    @todo = current_user.todos.build(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :user_id, :description, :priority, :completed)
    end
end
