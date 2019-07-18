Rails.application.routes.draw do
  # deviseは先頭に記述する必要がある
  devise_for :users

  # resourcesで指定できないをここで指定。 前に書いておかないと、users/:idが邪魔をして、adminページに行かない。

  # homeコントローラ関連
  get     "/"                           => "home#top",                as: "top"

  # usersコントローラ関連
  get     "users/:id/event"             => "users#event",             as: "event_user"
  get     "users/admin"                 => "users#admin",             as: "admin_user"
  # get     "users/admin/index"           => "users#admin_index",       as: "admin_index_user"
  get     "users/admin/:id"             => "users#admin_show",        as: "admin_show_user"

  # playsコントローラ関連
  # get     "plays/admin"                 => "plays#admin_index",       as: "admin_index_play"
  get     "plays/admin/new"             => "plays#admin_new",         as: "admin_new_play"
  get     "plays/admin/:id"             => "plays#admin_show",        as: "admin_show_play"
  post    "plays/admin"                 => "plays#admin_create",      as: "admin_create_play"
  get     "plays/admin/:id/edit"        => "plays#admin_edit",        as: "admin_edit_play"
  patch   "plays/admin/:id"             => "plays#admin_update",      as: "admin_update_play"
  delete  "plays/admin/:id"             => "plays#admin_destroy",     as: "admin_destroy_play"

  # eventコントローラ関連
  get     "events/:id/join"             => "events#join",             as: "join_event"
  get     "events/complete"             => "events#complete",         as: "complete_event"
  delete  "events/:id/cansel"           => "events#cansel",           as: "cansel_event"
  get     "events/admin"                => "events#admin",            as: "admin_event"
  get     "events/admin/:id"            => "events#admin_show",       as: "admin_show_event"
  delete  "events/admin/:id"            => "events#admin_destroy",    as: "admin_destroy_event"
  patch   "events/admin/:id/accept"     => "events#admin_accept",     as: "admin_accept_event"
  patch   "events/admin/:id/rescission" => "events#admin_rescission", as: "admin_rescission_event"


  # resources指定
  # index create new edit show update destroy が自動設定される
  resources :users, only: [:edit, :show, :update, :destroy]
  resources :plays, only: [:index, :show]
  # 全て使用するので、絞らない
  resources :events

  # rails routes の内容をコピー 2019/7/9時点
=begin
                         Prefix Verb        URI Pattern                                                                              Controller#Action
         new_user_session GET    /users/sign_in(.:format)                                                                                                                      devise/sessions#new
             user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
     destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
        new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
       edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
            user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
                          PUT    /users/password(.:format)                                                                devise/passwords#update
                          POST   /users/password(.:format)                                                                devise/passwords#create
 cancel_user_registration GET    /users/cancel(.:format)                                                                  devise/registrations#cancel
    new_user_registration GET    /users/sign_up(.:format)                                                                 devise/registrations#new
   edit_user_registration GET    /users/edit(.:format)                                                                    devise/registrations#edit
        user_registration PATCH  /users(.:format)                                                                         devise/registrations#update
                          PUT    /users(.:format)                                                                         devise/registrations#update
                          DELETE /users(.:format)                                                                         devise/registrations#destroy
                          POST   /users(.:format)                                                                         devise/registrations#create


                      top GET    /                                                                                        home#top


                edit_user GET    /users/:id/edit(.:format)                                                                users#edit             # ユーザー編集ページを表示
                     user GET    /users/:id(.:format)                                                                     users#show             # マイページを表示
                          PATCH  /users/:id(.:format)                                                                     users#update
                          PUT    /users/:id(.:format)                                                                     users#update
                          DELETE /users/:id(.:format)                                                                     users#destroy          # 退会機能
               event_user GET    /users/:id/event(.:format)                                                               users#event            # 主催者情報ページの表示
               admin_user GET    /users/admin(.:format)                                                                   users#admin            # 管理者マイページを表示
         admin_index_user GET    /users/admin/index(.:format)                                                             users#admin_index
          admin_show_user GET    /users/admin/:id(.:format)                                                               users#admin_show       # 管理者ユーザー詳細ページの表示


                    plays GET    /plays(.:format)                                                                         plays#index            # 遊び一覧ページを表示
                     play GET    /plays/:id(.:format)                                                                     plays#show             # 遊び詳細ページを表示
         admin_index_play GET    /plays/admin(.:format)                                                                   plays#admin_index
          admin_show_play GET    /plays/admin/:id(.:format)                                                               plays#admin_show       # (管理者)遊び詳細ページを表示
           admin_new_play GET    /plays/admin/new(.:format)                                                               plays#admin_new
        admin_create_play POST   /plays/admin(.:format)                                                                   plays#admin_create
          admin_edit_play GET    /plays/admin/:id/edit(.:format)                                                          plays#admin_edit       # 管理者遊び編集ページを表示
        admin_update_play PATCH  /plays/admin/:id(.:format)                                                               plays#admin_update     # 管理者遊び更新機能  
       admin_destroy_play DELETE /plays/admin/:id(.:format)                                                               plays#admin_destroy    # 管理者遊び削除機能


                   events GET    /events(.:format)                                                                        events#index           # イベント一覧ページを表示
                          POST   /events(.:format)                                                                        events#create
                new_event GET    /events/new(.:format)                                                                    events#new
               edit_event GET    /events/:id/edit(.:format)                                                               events#edit            # イベント編集ページを表示
                    event GET    /events/:id(.:format)                                                                    events#show
                          PATCH  /events/:id(.:format)                                                                    events#update
                          PUT    /events/:id(.:format)                                                                    events#update
                          DELETE /events/:id(.:format)                                                                    events#destroy         # イベント削除機能
               join_event GET    /events/:id/join(.:format)                                                               events#join
           complete_event GET    /events/complete(.:format)                                                               events#complete        # 参加完了ページを表示
             cansel_event DELETE /events/:id/cansel(.:format)                                                             events#cansel          # イベント参加キャンセル機能
              admin_event GET    /events/admin(.:format)                                                                  events#admin
         admin_show_event GET    /events/admin/:id(.:format)                                                              events#admin_show
      admin_destroy_event DELETE /events/admin/:id(.:format)                                                              events#admin_destroy   # イベント削除機能
       admin_accept_event PATCH  /events/admin/:id/accept(.:format)                                                       events#admin_accept    # イベント承認
   admin_rescission_event PATCH  /events/admin/:id/rescission(.:format)                                                   events#admin_rescission# イベント承認キャンセル
 


               refile_app        /attachments                                                                             #<Refile::App app_file="/home/vagrant/.bundle/ruby/2.5.0/refile-46b4178654e6/lib/refile/app.rb">
       rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
=end
  

  
end
