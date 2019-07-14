class UsersController < ApplicationController
  def show
    @user = current_user
    # 参加しているイベントだけDBから持ってくる
    @event_joins = EventJoin.where(user_id: @user.id)

    # 主催しているイベントだけDBから持ってくる
    @events = Event.where(user_id: @user.id)

    # 参加者の数を計算して、@event_counts_arrayに格納する処理
    @event_counts_array = Array.new
    @events.each do |event|
      @event_counts_array.push(EventJoin.where(event_id: event.id).count)
    end

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #パスワード変更するとログアウトしてしまうので、もう一度強制的にサインインさせてる。
      sign_in(@user, bypass: true)
      redirect_to user_path(@user.id)
    else
      render "edit"
    end
  end

  def destroy
    user = current_user

    # ユーザー側:退会のみ可能
    # 管理者側: 退会、退会キャンセル両方可能

    # 管理者の場合
    if user.admin_flg == 1

      

      user = User.find(params[:id])
      # 退会フラグが立っていない場合は、退会させる。
      # 退会フラグが立っている場合は、退会キャンセルさせる。
      if user.resignation_flg == nil
        user.resignation_flg = 1
      else
        if user.resignation_flg == 0
          user.resignation_flg = 1
        else
          user.resignation_flg = 0
        end
      end
      
      user.save

      # マイページに戻す
      redirect_to admin_user_path
      

    # ユーザーの場合
    else
      # 退会フラグを立てる
      user.resignation_flg = 1
      user.save

      # トップページに戻す
      redirect_to top_path
    end

  end

  def event
    @user = User.find(params[:id])
  end

  def admin
    @users = User.all
    @plays = Play.all
    @events = Event.all

    # 参加者の数を計算して、@event_counts_arrayに格納する処理
    @event_counts_array = Array.new
    @events.each do |event|
      @event_counts_array.push(EventJoin.where(event_id: event.id).count)
    end
  end

  def admin_index
  end

  def admin_show
  end

  # ストロングパラメータ
  private
  def user_params
    params.require(:user).permit(:id, :name_kanji_sei, :name_kanji_mei, :name_kana_sei, :name_kana_mei, :nickname, :email, :password, :phone_number, :payment_method, :user_image, :user_profile)
  end

end
