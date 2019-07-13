class UsersController < ApplicationController
  def show
    @user = current_user
    # 参加しているイベントだけDBから持ってくる
    @events = Event.where(user_id: @user.id)

  end

  def edit
  end

  def update
  end

  def destroy
    user = current_user
    # 退会フラグを立てる
    user.resignation_flg = 1
    user.save

    # トップページに戻す
    redirect_to top_path

  end

  def event
  end

  def admin
    @users = User.all
    @plays = Play.all
    @events = Event.all
  end

  def admin_index
  end

  def admin_show
  end
end
