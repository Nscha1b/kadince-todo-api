class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[ update destroy ]
  # still need to handle filtering...

  def index
    @todos = current_user.todos

    render json: @todos
  end

  def create
    @todo = current_user.todos.build(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @todo.destroy
      head :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  private
    def set_todo
      @todo = current_user.todos.find(params.expect(:id))
    end

    def todo_params
      params.expect(todo: [ :title, :user_id, :description, :priority, :completed ])
    end
end
