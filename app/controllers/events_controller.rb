class EventsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @events = current_user.events
  end
  
  def show
    @enent = current_user.enents.find(params[:id])
  end
  
  def new
  end
  
  def edit
  end
  
  def update
    @event = current_user.events.find(params[:id])
    @event.update(update_params)
    flash[:success] = "スケジュールを更新しました"
    redirect_to events_path(@user.id)
  end
  
  def create
    @events = current_user.events.build(event_params)
    if @events.save
      flash[:success] = "スケジュールを保存しました"
      redirect_to events_path(@user.id)
    else
      render 'new'
    end
  end
  
  def destroy
    @event = current_user.events.find(params[:id])
    @events.destroy
    flash.now[:info] = "スケジュールを削除しました"
    redirect_to events_path(@user.id)
  end
  
  
  private
    
  def event_params
    params.permit(:start_time,:title, :content,:user_id)
  end
  
  def update_params
    params.permit(:event).permit(:start_time,:title, :content,:user_id)
  end
  
end
