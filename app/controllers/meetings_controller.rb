class MeetingsController < ApplicationController
  before_action :set_user, only: [:show]
    
    def index
      @meetings = current_user.meetings 
    end
    
    def show
      @meetings = current_user.meetings.find(params[:id])
    end
   
    def new
    end
   
    def edit
      @meeting = current_user.meetings.find(params[:id])
    end
    
    def update
      @meeting = current_user.meetings.find(params[:id])
      if @meeting.update(update_params)
        flash[:success] = "編集完了"
        redirect_to meetings_path(current_user)
      else
        flash[:danger] = "編集が失敗しました"
        render "edit"
      end
    end
   
    def create
      @meeting = current_user.meetings.new(meeting_memo)
      if @meeting.save
        flash[:success] = "入力完了"
        redirect_to meetings_path(current_user)
      else
        flash[:danger] = "入力が失敗しました"
        render "new"
      end
    end
   
    def destroy
      @trainings = current_user.meetings.find(params[:id])
      @trainings.destroy
      redirect_to meetings_path(current_user)
    end
    
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def meeting_memo
      params.permit(:start_time,:title, :content,:user_id)
    end
   
    def update_params
      params.require(:meeting).permit(:start_time,:title, :content,:user_id)
    end
end
