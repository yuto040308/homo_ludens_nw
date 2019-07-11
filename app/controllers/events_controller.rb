class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
  end

  def join
  end

  def complete
  end

  def new
    @event = Event.new
    # プルダウンで遊びを選択させるため、遊びの一覧を渡す
    @plays = Play.all
  end

  def create
    event = Event.new(event_params)
    event.user_id = current_user.id

    # save成功時はマイページ、失敗時はnew画面に戻す
    if event.save
      redirect_to user_path(current_user.id)
    else
      render "new"
    end

  end

  def edit
  end

  def update
  end

  def destroy
  end

  def cansel
  end

  def admin_index
  end

  def admin_show
  end

  def admin_destroy
  end

  def admin_accept
  end

  # ストロングパラメーター
  private
  def event_params
    params.require(:event).permit(:id, :play_id, :event_title, :event_explain, :event_image, :event_place, :event_people_min, :event_people_max, :honorarium, :event_hold_start_time, :event_hold_finish_time, :event_start_time, :event_finish_time)
  end

end
