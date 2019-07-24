class EventsController < ApplicationController

  # 管理者ページはユーザーが見れないように制御をかける
  before_action :admin_flg_check?, only: [:admin_show, :admin_destroy, :admin_accept, :admin_rescission]
  # 退会しているユーザーは、一覧画面、詳細画面までしか見れないようにする
  before_action :resignation_flag_and_login_check?, only: [:join, :complete, :new, :create, :edit, :update, :destroy, :cansel, :admin_show, :admin_destroy, :admin_accept, :admin_rescission]

  def index
    # 承認フラグ立っているイベントのみ表示されるようにする
    #@events = Event.where(event_confirm_flg: 1)

    # 現在時刻の取得
    time_now_tokyo = DateTime.now.in_time_zone('Tokyo')

    # 承認フラグが立っており、かつ募集時刻が現在時刻を過ぎていないイベントを一覧で表示
    @events = Event.where("event_finish_time > ?", time_now_tokyo).where(event_confirm_flg: 1)
    #binding.pry
    #@events = Event.all
  end

  def show
    @event = Event.find(params[:id])

    
    # ユーザーがイベントに参加済みかを検索し、参加済みの場合フラグを立てる
    if current_user != nil
      if EventJoin.find_by(event_id: @event.id, user_id: current_user.id) != nil
        @event_join_flg = 1
      else
        @event_join_flg = 0
      end
    else
      @event_join_flg = 0
    end

    # 自分自身が作成したイベントに参加できないようにする
    if current_user != nil
      # 管理者もイベント参加できないようにする
      if @event.user_id == current_user.id || current_user.admin_flg == 1
        @event_my_flg = 1
      else
        @event_my_flg = 0
      end
    else
      @event_my_flg = 0
    end

    # 
    # 消費税を計算させる処理
    #
    taxes = Tax.all
    @tax = 0.00
    # 全レコード回して、最適な税率を持ってくる
    taxes.each do |tax|
      if tax.tax_start_finish_now? 
        @tax = tax.tax
        break
      end
    end
    # 処理終了

    # イベント参加者をカウントする処理
    @event_count = EventJoin.where(event_id: @event.id).count
    
  end

  def join
    event = Event.find(params[:id])
    event_join = EventJoin.new

    # すでに参加している場合と、募集時間外は保存できなくする
    if EventJoin.find_by(event_id: event.id, user_id: current_user.id) != nil ||
      event.collect_start_now_finish? == false

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
    @create_error_array = Array.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    # エラー文を格納する関数を定義する
    @create_error_array = Array.new

    # 必須のパラメータが入っているか確認し、入っていない場合は元の画面に戻す
    if @event.essential_params_check? == false
      @create_error_array.push("入力されていない必須項目があります。")
      # プルダウンで遊びを選択させるため、遊びの一覧を渡す
      @plays = Play.all
      # renderは表示させているだけなので、returnがないと先に処理がすすんでしまう。
      return render "new"
    end

    if @event.event_save_before_check?(@create_error_array) == false
      # プルダウンで遊びを選択させるため、遊びの一覧を渡す
      @plays = Play.all
      return render "new"
    end

    # save成功時はマイページ、失敗時はnew画面に戻す
    if @event.save
      flash[:notice] = "イベント新規作成が完了しました"
      redirect_to user_path(current_user.id)
    else
      # プルダウンで遊びを選択させるため、遊びの一覧を渡す
      @plays = Play.all
      render "new"
    end



=begin 旧処理 一応正しく動くっぽい
    # 現在時刻よりも後に入力されているか確認し、エラーの場合は元の画面に戻す
    if @event.event_hold_start_time_now_after? && @event.event_hold_finish_time_now_after? &&
       @event.event_start_time_now_after? && @event.event_finish_time_now_after?


      # 募集開始時刻 < 募集終了時刻、開催開始時刻 < 開催終了時刻 になっているか確認し、
      # 整合性が合わない場合は、元の画面に戻す
      if @event.event_hold_time_from_to? && @event.event_collect_time_from_to?

        # イベント開始時刻 < 募集終了時刻になっているか確認。整合性が合わない場合は元の画面に戻す
        if @event.event_collect_hold_time?

          # 最小催行人数<最大催行人数になっているかチェックする
          if @event.event_join_peoples_min_max?
            # save成功時はマイページ、失敗時はnew画面に戻す
            if @event.save
              flash[:notice] = "イベント新規作成が完了しました"
              redirect_to user_path(current_user.id)
            else
              # プルダウンで遊びを選択させるため、遊びの一覧を渡す
              @plays = Play.all
              render "new"
            end
          else
            flash[:notice] = "最大催行人数は、最小催行人数以上で入力してください"
            # プルダウンで遊びを選択させるため、遊びの一覧を渡す
            @plays = Play.all
            render "new"
          end

          

        # 整合性が合わない場合、エラーメッセージを渡す
        else
          flash[:notice] = "イベント開始時刻は、募集終了時刻より後の時刻で入力してください"
          # プルダウンで遊びを選択させるため、遊びの一覧を渡す
          @plays = Play.all
          render "new"
        end

        

      # 整合性が合わない場合、エラーメッセージを渡す
      else
        flash[:notice] = "開始時刻 < 終了時刻 で入力してください"
        # プルダウンで遊びを選択させるため、遊びの一覧を渡す
        @plays = Play.all
        render "new"
      end

      

    # エラーの場合
    else
      flash[:notice] = "現在時刻よりも後の時刻を入力してください"
      # プルダウンで遊びを選択させるため、遊びの一覧を渡す
      @plays = Play.all
      render "new"
    end
=end

  end

  def edit
    @event = Event.find(params[:id])
    # プルダウンで遊びを選択させるため、遊びの一覧を渡す
    @plays = Play.all
    @edit_error_array = Array.new
  end

  def update
    @event = Event.find(params[:id])
    check_event = Event.new(event_params)
    # プルダウンで遊びを選択させるため、遊びの一覧を渡す
    @plays = Play.all

    # エラー文を格納する関数を定義する
    @edit_error_array = Array.new

    # 必須のパラメータが入っているか確認し、入っていない場合は元の画面に戻す
    if check_event.essential_params_check? == false
      @edit_error_array.push("入力されていない必須項目があります。")
      # renderは表示させているだけなので、returnがないと先に処理がすすんでしまう。
      return render "edit"
    end

    if check_event.event_save_before_check?(@edit_error_array) == false
      return render "edit"
    end

    # save成功時はマイページ、失敗時はedit画面に戻す
    if @event.update(event_params)
      flash[:notice] = "イベント更新が完了しました"
      redirect_to user_path(current_user.id)
    else
      render "edit"
    end


=begin 一応これでも動く
    if @event.update(event_params)
      flash[:notice] = "イベント更新が完了しました"
      redirect_to user_path(current_user.id)
    else
      render "edit"
    end
=end
  end

  def destroy
    # 主催しているイベントを取得する。
    event = Event.find(params[:id])

    flash[:notice] = "イベント削除が完了しました"

    event.destroy

    # マイページに戻す
    redirect_to user_path(current_user.id)
  end

  def cansel
    # イベント参加しているレコードを取得する。
    event = Event.find(params[:id])
    event_join = EventJoin.find_by(event_id: params[:id], user_id: current_user.id)

    # 募集終了日をすぎていたら、キャンセルできないようにする。
    if event.event_finish_time_now_after?
      flash[:notice] = "参加キャンセルが完了しました"
      event_join.destroy
    else
      flash[:notice] = "募集終了日を過ぎているため、キャンセル出来ません。"
    end

    # マイページに戻す
    redirect_to user_path
    
  end

  def admin_show
    @event = Event.find(params[:id])
  end

  def admin_destroy
    # 主催しているイベントを取得する。
    event = Event.find(params[:id])

    flash[:notice] = "イベント削除が完了しました"
    event.destroy

    # マイページに戻す
    redirect_to admin_user_path
  end

  def admin_accept
    event = Event.find(params[:id])
    event.event_confirm_flg = 1
    event.save
    flash[:notice] = "イベントを承認しました"

    # マイページに戻す
    redirect_to admin_user_path

  end

  def admin_rescission
    event = Event.find(params[:id])
    event.event_confirm_flg = 0
    event.save
    flash[:notice] = "イベントの承認を解除しました"

    # マイページに戻す
    redirect_to admin_user_path

  end

  # 保存前に整合性を確認し、Arrayクラスにエラーをpushして最後にsave可否を返す
  # @付きの変数は渡せないみたい。@event → eventにすると渡せた。
  def event_save_before_check?(array, event)

    save_flg = 1

    if event.event_hold_start_time_now_after? == false
      array.push("イベント開始時刻を、現在時刻よりも後に入力してください。")
      save_flg = 0
    end

    if event.event_hold_finish_time_now_after? == false
      array.push("イベント終了時刻を、現在時刻よりも後に入力してください。")
      save_flg = 0
    end

    if event.event_start_time_now_after? == false
      array.push("イベント募集開始時刻を、現在時刻よりも後に入力してください。")
      save_flg = 0
    end

    if event.event_finish_time_now_after? == false
      array.push("イベント募集終了時刻を、現在時刻よりも後に入力してください。")
      save_flg = 0
    end

    if event.event_hold_time_from_to? == false
      array.push("募集開始時刻が、募集終了時刻よりも前になっていません。")
      save_flg = 0
    end

    if event.event_collect_time_from_to? == false
      array.push("イベント開始時刻が、イベント終了時刻よりも前になっていません。")
      save_flg = 0
    end

    # イベント開始時刻 > 募集終了時刻になっているか確認。
    if event.event_collect_hold_time? == false
      array.push("募集終了時刻が、イベント開始時刻よりも前になっていません。")
      save_flg = 0
    end

    # 最小催行人数<最大催行人数になっているかチェックする
    if event.event_join_peoples_min_max? == false
      array.push("最大催行人数は、最小催行人数以上で入力してください")
      save_flg = 0
    end

    if save_flg == 1
      return true
    else
      return false
    end

  end


  # ストロングパラメーター
  private
  def event_params
    params.require(:event).permit(:id, :play_id, :event_title, :event_explain, :event_image, :event_place, :event_people_min, :event_people_max, :honorarium, :event_hold_start_time, :event_hold_finish_time, :event_start_time, :event_finish_time)
  end

end
