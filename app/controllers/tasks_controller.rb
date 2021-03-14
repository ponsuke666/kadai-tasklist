class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit]
  
  def index
    if logged_in?
      @task = current_user.tasks.build
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを登録しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'タスクの登録に失敗しました。'
      render 'tasks/index'
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'タスクは更新されませんでした。'
      render :edit
    end
  end
  
  private

  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end
