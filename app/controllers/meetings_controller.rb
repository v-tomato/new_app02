class MeetingsController < ApplicationController
    
    def index
      @meetings = current_user.meetings 
    end
    
    def show
    end
   
    def new
    end
   
    def edit
      @meeting = current_user.meetings.find(params[:id])
    end
    
    def update
      @meeting = current_user.meetings.find(params[:id])
      @meeting.update(update_params)
      redirect_to meetings_path(@user.id)
    end
   
    def create
      @meeting = current_user.meetings.new(meeting_memo)
      if @meeting.save
        flash[:success] = "入力完了"
        redirect_to meetings_path(@user.id)
      else
        flash[:danger] = "入力が失敗しました"
        render "new"
      end
    end
   
    def destroy
      @trainings = current_user.meetings.find(params[:id])
      @trainings.destroy
      redirect_to meetings_path(@user.id)
    end
    
    
    private
    
    def meeting_memo
      params.permit(:start_time,:title, :content,:user_id)
    end
   
    def update_params
      params.require(:meeting).permit(:start_time,:title, :content,:user_id)
    end
end
