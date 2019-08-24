require 'rails_helper' # これは書く必要がある
require "refile/file_double" # refileのテストをするため、この記述が必要。
RSpec.describe EventsController, type: :controller do

    describe "イベント一覧ページ #index" do
        context "イベント一覧ページが正しく表示される" do
            before do
                # spec/factories/event.rbに定義してあるevent1とevent2のを2つを作成する。
                FactoryBot.create(:event1)
                FactoryBot.create(:event2)
                get :index
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end

            it "全件DBから取得できているか" do
                expect(controller.instance_variable_get("@events").length).to eq 2
            end

        end
    end

    describe "イベント詳細ページ #show" do
        context "イベント詳細ページが正しく表示される" do
            before do
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
                FactoryBot.create(:tax)
                get :show, params: {id: @event.id }
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end

            it "消費税をDBから取得できているか" do
                expect(controller.instance_variable_get("@tax")).to eq 1.08
            end
        end
    end

    describe "イベント参加 #join" do
        context "イベントに正しく参加できる" do
            before do
                # spec/factories/event.rbに定義してあるevent3を作成する。
                # 募集期間内のイベントしか参加できないため、event3を使用した。
                @event = FactoryBot.create(:event3)
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
            end

            it 'EventJoinテーブルに追加されていること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                expect {

                    get :join, params: {id: @event.id }

                # change : 状態が変わったか検証する by(1)をつけたことにより、1行増えたかを確認
                }.to change(EventJoin, :count).by(1)

            end
        end
    end

    describe "イベント参加完了 #complete" do
        context "イベント参加完了ページが正しく表示される" do
            before do
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :index
            end

            it "リクエストは200 OKとなること" do
                expect(response.status).to eq 200
            end
        end
    end

    describe "イベント新規作成ページ #new" do
        context "イベント新規作成ページが正しく表示される" do
            before do
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :new
            end

            it "リクエストは200 OKとなること" do
                expect(response.status).to eq 200
            end
        end
    end


    describe "イベント新規作成 #create" do

        # 正常値をあらかじめハッシュに定義
        event_param = {
            play_id: 1,
            user_id: 1,
            event_title: "テストタイトル",
            event_explain: "テスト説明です",
            event_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"), # refileのヘルパーを呼ぶ
            event_place: "テスト場所",
            event_people_min: 5,
            event_people_max: 10,
            honorarium: 10000,
            event_hold_start_time: DateTime.new(2050, 10, 10, 10, 00, 00),
            event_hold_finish_time: DateTime.new(2050, 10, 10, 17, 00, 00),
            event_start_time: DateTime.new(2049, 11, 11, 10, 00, 00),
            event_finish_time: DateTime.new(2050, 9, 20, 10, 00, 00),
            event_confirm_flg: 1
        }

        context "イベントの新規作成が正しく行われる" do
            before do
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
                
            end

            it "1件作成されていること" do

                # deviseのヘルパー@userをログイン状態にする。]
                # なぜかbefore内で宣言すると動かなかった
                sign_in @user
            
                # DBに正常値を入れる
                expect {
                    post :create, params: {event: event_param}
                # change : 状態が変わったか検証する by(1)をつけたことにより、1行増えたかを確認
                }.to change(Event, :count).by(1)
    
            end

            it "リダイレクトされること" do
                # deviseのヘルパー@userをログイン状態にする。]
                # なぜかbefore内で宣言すると動かなかった
                sign_in @user

                # DBに正常値を入れる。定義したハッシュ構造を呼ぶ
                post :create, params: {event: event_param}

                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to user_path(@user.id)

            end
            
            it 'flash[:notice]にメッセージが含まれているか' do
                # deviseのヘルパー@userをログイン状態にする。]
                # なぜかbefore内で宣言すると動かなかった
                sign_in @user

                # DBに正常値を入れる。定義したハッシュ構造を呼ぶ
                post :create, params: {event: event_param}

                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("イベント新規作成が完了しました")

            end
        end

        
    end

    describe 'イベント編集ページ #edit' do
        context "イベント編集ページが正しく表示される" do
            before do
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :edit, params: {id: @event.id }
            end

            it "リクエストは200 OKとなること" do
                expect(response.status).to eq 200
            end
            
        end
    end

    describe "イベント更新 #update" do

        # 変更する値をハッシュで定義しておく
        event_param = {
            play_id: 2,
            user_id: 2,
            event_title: "テストタイトル2",
            event_explain: "テスト2説明です",
            event_image: Refile::FileDouble.new("dummy", "logo2.png", content_type: "image/png"),
            event_place: "テスト場所2",
            event_people_min: 10,
            event_people_max: 20,
            honorarium: 12000,
            event_hold_start_time: DateTime.new(2051, 10, 10, 10, 00, 00),
            event_hold_finish_time: DateTime.new(2051, 10, 10, 17, 00, 00),
            event_start_time: DateTime.new(2050, 11, 11, 10, 00, 00),
            event_finish_time: DateTime.new(2051, 9, 20, 10, 00, 00),
            event_confirm_flg: 1
        }

        context "イベントが更新されるか" do
            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
            end

            it "イベントの内容が書き換わるか" do
                # 正常値を渡す
                patch :update, params: {id: @event.id, event: event_param}
                # 変更されているか確認 reloadと記入する必要がある
                expect(@event.reload.play_id).to eq 2
                expect(@event.reload.event_title).to eq "テストタイトル2"
                expect(@event.reload.event_explain).to eq "テスト2説明です"
                expect(@event.reload.event_image_id).not_to be_nil # refileを使っている所は単純に比較できないのでnilじゃないかを確認する
                expect(@event.reload.event_place).to eq "テスト場所2"
                expect(@event.reload.event_people_min).to eq 10
                expect(@event.reload.event_people_max).to eq 20
                expect(@event.reload.honorarium).to eq 12000
                expect(@event.reload.event_hold_start_time).to eq DateTime.new(2051, 10, 10, 10, 00, 00)
                expect(@event.reload.event_hold_finish_time).to eq DateTime.new(2051, 10, 10, 17, 00, 00)
                expect(@event.reload.event_start_time).to eq DateTime.new(2050, 11, 11, 10, 00, 00)
                expect(@event.reload.event_finish_time).to eq DateTime.new(2051, 9, 20, 10, 00, 00)
                
            end

            it "リダイレクトされること" do
                # 正常値を渡す
                patch :update, params: {id: @event.id, event: event_param}

                # 正常系のリダイレクト先に移動していること
                expect(response).to redirect_to user_path(@user.id)
            end

            it "flash[:notice]にメッセージが含まれているか" do
                # 正常値を渡す
                patch :update, params: {id: @event.id, event: event_param}

                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq "イベント更新が完了しました"
            end

        end
    end

    describe "イベント削除 #destroy" do
        context "1件正常に削除されているか" do

            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
            end

            it "1件削除されていること" do

                # 1レコード減ったか確認
                expect { 
                    delete :destroy, params: { id: @event.id }
                }.to change(Event, :count).by(-1)

            end

            it "リダイレクトされること" do

                # DBから削除する。
                delete :destroy, params: { id: @event.id }

                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to user_path(@user.id)

            end

            it "flash[:notice]にメッセージが含まれているか" do

                # DBから削除する。
                delete :destroy, params: { id: @event.id }
            
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("イベント削除が完了しました")

            end

        end
    end

    describe "イベントキャンセル #cansel" do

        context "イベント参加テーブルの中身は正常に削除されているか" do

            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
                # spec/factories/event.rbに定義してあるeventjoinを作成する。
                @event = FactoryBot.create(:eventjoin)
            end

            it "1件削除されていること" do

                # 1レコード減ったか確認
                expect { 
                    delete :cansel, params: { id: @event.id }
                }.to change(EventJoin, :count).by(-1)

            end

            it "リダイレクトされること" do

                delete :cansel, params: {id: @event.id}

                # 正常系のリダイレクト先に移動していること
                expect(response).to redirect_to user_path

            end

            it "flash[:notice]にメッセージが含まれているか" do
                
                delete :cansel, params: {id: @event.id}

                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq "参加キャンセルが完了しました"
            end

        end
    end

    describe "管理者用イベント詳細ページ #admin_show" do
        # ここを書き直す事
        context "管理者用イベント詳細ページが正しく表示される" do
            before do
                # spec/factories/event.rbに定義してあるevent1と表示に必要な消費税テーブルを作成する。
                @event = FactoryBot.create(:event1)

                # 管理者のログインが必要
                @user = FactoryBot.create(:admin_user)

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                get :admin_show, params: {id: @event.id }
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
    end

    describe "管理者イベント削除 #admin_destroy" do
        context "1件正常に削除されているか" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                # spec/factories/event.rbに定義してあるevent1を作成する。
                @event = FactoryBot.create(:event1)
            end

            it "1件削除されていること" do

                # 1レコード減ったか確認
                expect { 
                    delete :admin_destroy, params: { id: @event.id }
                }.to change(Event, :count).by(-1)

            end

            it "リダイレクトされること" do

                # DBから削除する。
                delete :admin_destroy, params: { id: @event.id }

                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path

            end

            it "flash[:notice]にメッセージが含まれているか" do

                # DBから削除する。
                delete :admin_destroy, params: { id: @event.id }
            
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("イベント削除が完了しました")

            end

        end
    end

    describe "管理者イベント承認 #admin_accept" do
        context "1件正常に承認されるか" do

            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                # spec/factories/event.rbに定義してある、承認フラグ0のevent4を作成する。
                @event = FactoryBot.create(:event4)

                get :admin_accept, params: {id: @event.id }
            end

            it "承認フラグが立っていること" do
                # 1:承認
                expect(@event.reload.event_confirm_flg).to eq 1
            end

            it "リダイレクトされること" do
                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path
            end

            it "flash[:notice]にメッセージが含まれているか" do           
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("イベントを承認しました")
            end

        end

    end

    describe "管理者イベント承認解除 e#admin_rescission" do
        context "1件正常に承認解除されるか" do

            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                # spec/factories/event.rbに定義してある、承認フラグ1のevent1を作成する。
                @event = FactoryBot.create(:event1)

                get :admin_rescission, params: {id: @event.id }
            end

            it "承認フラグが削除されていること" do
                # 0:未承認
                expect(@event.reload.event_confirm_flg).to eq 0
            end

            it "リダイレクトされること" do
                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path
            end

            it "flash[:notice]にメッセージが含まれているか" do           
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("イベントの承認を解除しました")
            end

        end
    end

    



end