class MeetingsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
    
    def index
      @user = current_user
      @meetings = current_user.meetings 
    end
    
    def show
      @user = current_user
      # @meeting = current_user.meetings.find(params[:id])
      @meeting = current_user.meetings.find(id)
    end
   
    def new
      @user = current_user
      @meeting = current_user.meetings
    end
   
    def edit
      @user = current_user
      @meeting = current_user.meetings.find(params[:id])
    end
    
    def update
      @user = current_user
      @meeting = current_user.meetings.find(params[:id])
      if @meeting.update(update_params)
        flash[:success] = "変更完了"
        redirect_to meetings_path(id: current_user)
      else
        flash[:danger] = "変更が失敗しました"
        render "edit"
      end
    end
   
    def create
      @user = current_user
      @meeting = current_user.meetings.build(meeting_memo)if logged_in?
      # @meeting = @user.meetings.build(meeting_memo)if logged_in?
      if @meeting.save!
        flash[:success] = "入力完了"
        redirect_to meetings_path(id: current_user)
      else
        flash[:danger] = "入力が失敗しました"
        render "new"
      end
    end
   
    def destroy
      @user = current_user
      @meeting = current_user.meetings.find(params[:id])
      @meeting.destroy
      flash[:success] = "削除しました"
      redirect_to meetings_path(id: current_user)
      
    end
    
    
    private
    
    def meeting_memo
      # params.permit(:start_time,:title, :content,:user_id)
      params.require(:meeting).permit(:start_time,:title, :content,:user_id)
    end
   
    def update_params
      params.require(:meeting).permit(:start_time,:title, :content,:user_id)
    end
end
