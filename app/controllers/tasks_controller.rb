class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all.page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    # redirect_to tasks_url
    redirect_back(fallback_location: root_url)
  end

  private
  # Strong Parameter
  def set_task
    @task = Task.find_by(id: params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def check_user
    if @task.blank? or @task.user != current_user
      redirect_to root_url
    end
  end
end

