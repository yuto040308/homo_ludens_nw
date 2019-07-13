class UsersController < ApplicationController
  def show
  end

  def edit
  end

  def update
  end

  def destroy
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
