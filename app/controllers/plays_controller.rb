class PlaysController < ApplicationController
  def index
    @plays = Play.all
  end

  def show
    @play = Play.find(params[:id])
    @events = Event.where(play_id: @play.id)
  end

  def admin_index
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
    play = Play.find(params[:id])

    if play.update(play_params)
      redirect_to admin_user_path
    else
      render "admin_edit"
    end

  end

  def admin_destroy
    play = Play.find(params[:id])

    play.destroy
    # マイページに戻す
    redirect_to admin_user_path
  end

  # ストロングパラメーター
  private
  def play_params
    params.require(:play).permit(:id ,:category_id, :play_title, :play_explain, :play_image)
  end
end
