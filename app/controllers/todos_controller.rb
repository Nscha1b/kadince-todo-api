require "tempfile"

class TodosController < ApplicationController
  # # include ActionView::Rendering
  # include ActionView::Layouts

  before_action :authenticate_user!
  before_action :set_todo, only: %i[ update destroy ]
  rate_limit to: 10, within: 3.minutes, only: :create

  def index
    @todos = TodoFilter.new(current_user.todos, todos_params).call

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

    def todos_params
      params.permit(:completed)
    end
end
