class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def join
    event = Event.find(params[:id])
    event_join = EventJoin.new

    # すでに参加している場合は保存できなくする
    if EventJoin.find_by(event_id: event.id, user_id: current_user.id) != nil
      # 処理しません
      redirect_to event_path(event.id)
    # 参加をまだしていない場合
    else

      # 値をセットする
      event_join.event_id = event.id
      event_join.user_id = current_user.id
      

      # save成功時は参加完了ページ、失敗時はイベント詳細画面に戻す
      if event_join.save
        redirect_to complete_event_path
      else
        redirect_to event_path(event.id)
      end
    end

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
    # 主催しているイベントを取得する。
    event = Event.find(params[:id])

    event.destroy

    # マイページに戻す
    redirect_to user_path
  end

  def cansel
    # イベント参加しているレコードを取得する。
    event_join = EventJoin.find_by(event_id: params[:id], user_id: current_user.id)

    event_join.destroy

    # マイページに戻す
    redirect_to user_path
    
  end

  def admin_index
  end

  def admin_show
  end

  def admin_destroy
  end

  def admin_accept
    event = Event.find(params[:id])
    event.event_confirm_flg = 1
    event.save

    # マイページに戻す
    redirect_to admin_user_path

  end

  def admin_rescission
    event = Event.find(params[:id])
    event.event_confirm_flg = 0
    event.save

    # マイページに戻す
    redirect_to admin_user_path

  end

  # ストロングパラメーター
  private
  def event_params
    params.require(:event).permit(:id, :play_id, :event_title, :event_explain, :event_image, :event_place, :event_people_min, :event_people_max, :honorarium, :event_hold_start_time, :event_hold_finish_time, :event_start_time, :event_finish_time)
  end

end
