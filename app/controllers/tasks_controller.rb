class TasksController < ApplicationController
  
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
    #  @task = current_user.tasks.build # form_with用課題では、フォーム無いので使わず
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]) #一覧表示用
    end
    
    # 元々@tasks = Task.order(id: :desc).page(params[:page]).per(5)
     
  end
  
  
  def show
    set_task
  end
  
  
  def new
    @task = Task.new
  end
  
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to root_url
      
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render :new
    end
  end
  
  
  def edit
    set_task
  end
  
  
  def update
    set_task
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
      
  end
  
  
  def destroy
    set_task
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url 
    # 今回の課題にはNG redirect_back(fallback_location: root_path)
  end
  
  
  
  private
  
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end
  
  # Strong Parameter
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
