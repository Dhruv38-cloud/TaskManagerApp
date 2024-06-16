class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy change_state]

  def index
    @tasks = current_user.tasks
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def change_state
    if @task.update(state: params[:state])
      redirect_to @task, notice: 'Task state was successfully updated.'
    else
      redirect_to @task, alert: 'Failed to update task state.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :state, :deadline)
    end
end
