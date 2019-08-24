class PlaysController < ApplicationController

  # 管理者ページはユーザーが見れないように制御をかける
  before_action :admin_flg_check?, only: [:admin_show, :admin_new, :admin_create, :admin_edit, :admin_update, :admin_destroy]
  # 退会しているユーザーは、一覧画面、詳細画面までしか見れないようにする
  before_action :resignation_flag_and_login_check?, only: [:admin_show, :admin_new, :admin_create, :admin_edit, :admin_update, :admin_destroy]


  def index
    @plays = Play.all
  end

  def show
    @play = Play.find(params[:id])
    @events = Event.where(play_id: @play.id)
  end

  def admin_show
    @play = Play.find(params[:id])
  end

  def admin_new
    @play = Play.new
    # プルダウンでジャンルを選択させるため、ジャンルの一覧を渡す
    @categories = Category.all
  end

  def admin_create

    @play = Play.new(play_params)

    # save成功時は管理者ページ、失敗時はnew画面に戻す
    if @play.save
      flash[:notice] = "遊びを新規作成しました"
      redirect_to admin_user_path
    else
      # render先に@categoriesがないため、作成する必要あり
      # プルダウンでジャンルを選択させるため、ジャンルの一覧を渡す
      @categories = Category.all
      render "admin_new"
    end

  end

  def admin_edit
    @play = Play.find(params[:id])
    # カテゴリ表示のため、取得
    @categories = Category.all
  end

  def admin_update
    @play = Play.find(params[:id])

    if @play.update(play_params)
      flash[:notice] = "遊びを更新しました"
      redirect_to admin_user_path
    else
      # カテゴリ表示のため、取得
      @categories = Category.all
      render "admin_edit"
    end

  end

  def admin_destroy
    play = Play.find(params[:id])

    play.destroy
    flash[:notice] = "遊びを削除しました"
    # マイページに戻す
    redirect_to admin_user_path
  end

  # 検索用
  def search
    @search = Play.new(play_params)
    

    # play_delete_flgを処理分岐の材料として使う。
    # play_delete_flg: 0 => 遊びの検索
    # play_delete_flg: 1 => イベントの検索
    if @search.play_delete_flg == 0
      @plays = Play.where(play_title: @search.play_title)
      render "index"
    else
      # 現在時刻の取得
      time_now_tokyo = DateTime.now.in_time_zone('Tokyo')
      # 承認フラグが立っており、かつ募集時刻が現在時刻を過ぎていないイベントかつ、検索文字に該当するレコードを一覧で表示
      @events = Event.where("event_finish_time > ?", time_now_tokyo).where(event_confirm_flg: 1, event_title: @search.play_title)
      # eventコントローラのindex.htmlに遷移させる。
      render "events/index"
    end

    
  end

  # ストロングパラメーター
  private
  def play_params
    params.require(:play).permit(:id ,:category_id, :play_title, :play_explain, :play_image, :play_delete_flg)
  end
end
