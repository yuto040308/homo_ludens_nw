require 'rails_helper' # これは書く必要がある
require "refile/file_double" # refileのテストをするため、この記述が必要。
RSpec.describe PlaysController, type: :controller do
    describe '遊び一覧ページ #index' do
      context "遊び一覧ページが正しく表示される" do

        before do
          get :index
        end

        it 'リクエストは200 OKとなること' do
          expect(response.status).to eq 200
        end
      end
    end

    describe '遊び詳細ページ #show' do
        context "遊び詳細ページが正しく表示される" do
  
          before do
            # テスト用のデータを作成しておく
            @play = Play.new(
                category_id: 1,
                play_title: "テストタイトル",
                play_explain: "テスト説明文"
                )
            @play.save
          end
  
          it 'リクエストは200 OKとなること' do
            # params[:id]の値を渡してやる
            get :show, params: {id: @play.id}
            expect(response.status).to eq 200
          end
        end
    end

    describe '管理者用遊び詳細ページ #admin_show' do
        context "管理者用遊び詳細ページが正しく表示される" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # テスト用のデータを作成しておく
                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト説明文"
                    )
                @play.save
            end
            it 'リクエストは200 OKとなること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # params[:id]の値を渡してやる
                get :admin_show, params: {id: @play.id}
                expect(response.status).to eq 200
            end
        end
    end

    describe '管理者遊び新規作成ページ #admin_new' do
        context "管理者用遊び新規作成ページが正しく表示される" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                
            end
    
            it 'リクエストは200 OKとなること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # new画面を表示
                get :admin_new
                expect(response.status).to eq 200
            end
        end
    end

    describe '管理者遊び新規作成 #admin_create' do
        context "新規投稿が正常に作成できるか" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                
            end
    
            it '1件作成されていること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                expect {
                    post :admin_create, params: {
                        play: {
                            category_id: 1,
                            play_title: "テストタイトル",
                            play_explain: "テスト説明です",
                            play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                            play_delete_flg: 1
                        }
                    }
                # change : 状態が変わったか検証する by(1)をつけたことにより、1行増えたかを確認
                }.to change(Play, :count).by(1)

            end

            it 'リダイレクトされること' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                post :admin_create, params: {
                        play: {
                            category_id: 1,
                            play_title: "テストタイトル",
                            play_explain: "テスト説明です",
                            play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                            play_delete_flg: 1
                        }
                    }
                
                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path
            end

            it 'flash[:notice]にメッセージが含まれているか' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                post :admin_create, params: {
                    play: {
                        category_id: 1,
                        play_title: "テストタイトル",
                        play_explain: "テスト説明です",
                        play_image_id: "fjwoewjfiowjifel",  # 画像は文字になるので、適当な値を入力
                        play_delete_flg: 1
                    }
                }
            
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("遊びを新規作成しました")

            end
        end
    end

    describe '管理者遊び編集ページ #admin_edit' do
        context "管理者遊び編集ページが正しく表示される" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # テスト用のデータを作成しておく
                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト説明文"
                )
                @play.save
                
            end
    
            it 'リクエストは200 OKとなること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # edit画面を表示
                get :admin_edit, params: {id: @play.id}
                expect(response.status).to eq 200
            end
        end
    end

    describe "管理者遊び更新ページ #admin_update" do
        context "遊びの投稿が更新されるか" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # テスト用のデータを作成しておく
                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト説明文",
                    play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                    play_delete_flg: 1
                )
                @play.save
                
            end

            it '記事が更新されるか' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # updateメゾットを呼ぶ
                patch :admin_update, params: {
                    id: @play.id, # 保存したidで検索をかける

                    play: {
                        category_id: 2,
                        play_title: "テストタイトル２",
                        play_explain: "テスト２説明です",
                        # require "refile/file_double"を宣言したことにより、ダミーのファイルを指定できるようになった
                        play_image: Refile::FileDouble.new("dummy", "logo2.png", content_type: "image/png"),
                        play_delete_flg: 0
                    }
                }
                # 変更されているか確認 reloadと記入する必要がある
                expect(@play.reload.category_id).to eq 2
                expect(@play.reload.play_title).to eq "テストタイトル２"
                expect(@play.reload.play_explain).to eq "テスト２説明です"
                expect(@play.reload.play_image_id).not_to be_nil
                expect(@play.reload.play_delete_flg).to eq 0
            end

            it 'リダイレクトされること' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                patch :admin_update, params: {
                    id: @play.id, # 保存したidで検索をかける
                        play: {
                            category_id: 1,
                            play_title: "テストタイトル",
                            play_explain: "テスト説明です",
                            play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                            play_delete_flg: 1
                        }
                    }
                
                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path
            end

            it 'flash[:notice]にメッセージが含まれているか' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                post :admin_update, params: {
                    id: @play.id, # 保存したidで検索をかける
                    play: {
                        category_id: 1,
                        play_title: "テストタイトル",
                        play_explain: "テスト説明です",
                        play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                        play_delete_flg: 1
                    }
                }
            
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("遊びを更新しました")

            end

        end
    end

    describe '管理者遊び削除 #admin_destroy' do
        context "投稿が1件正常に削除されているか" do

            before do
                # あらかじめFacrotyBotで登録しておいた管理者ユーザーを作成する
                @user = FactoryBot.create(:admin_user)

                # 削除するためのデータを作成
                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト説明です",
                    play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                    play_delete_flg: 1
                )

                @play.save
                
            end
    
            it '1件削除されていること' do
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBに正常値を入れる
                expect { 
                    delete :admin_destroy, params: { id: @play.id }
                # change : 状態が変わったか検証する by(-1)をつけたことにより、1行減ったかを確認
                }.to change(Play, :count).by(-1)

            end


            it 'リダイレクトされること' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBから削除する。
                delete :admin_destroy, params: { id: @play.id }

                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to admin_user_path

            end

            it 'flash[:notice]にメッセージが含まれているか' do

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # DBから削除する。
                delete :admin_destroy, params: { id: @play.id }
            
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("遊びを削除しました")

            end

        end
    end

    describe "検索 #search" do
        # ログインは不要だと思う
        # まずは遊びの検索をする
        # ストロングパラメーターにplay_titleをいれる（これがキーになる）
        # @search.play_delete_flg == 0: 遊びの検索
        context "遊びの検索が出来る" do

            # あらかじめ検索対象のデータをDBに保存しておく
            before do
                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト説明です",
                    play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                    play_delete_flg: 1
                )

                # 保存
                @play.save

                @play = Play.new(
                    category_id: 1,
                    play_title: "テストタイトル",
                    play_explain: "テスト2件目説明です",
                    play_image: Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png"),
                    play_delete_flg: 0
                )

                # 保存
                @play.save
            end

            # 遊びが検索できるか
            it "遊びが検索できること" do

                post :search, params: {
                    id: @play.id,
                    play: {
                        play_title: "テストタイトル",
                        play_delete_flg: 0  # 0:遊び検索 1:イベント検索
                    }
                }

                # 2件検索ができたか確認する。
                # controller.instance_variable_get("@plays") でコントローラ内の変数を見れる。
                expect(controller.instance_variable_get("@plays").length).to eq 2

            end

            # 正しくrender先を読み込めているか
            it "render先があっている事" do

                post :search, params: {
                    play: {
                        play_title: "テストタイトル",
                        play_delete_flg: 0  # 0:遊び検索 1:イベント検索
                    }
                }

                # index.htmlが呼ばれること
                expect(response).to render_template(:index)
            end

        end

        context "イベントの検索が出来る" do
            before do
                # spec/factories/event.rbに定義してあるevent1とevent2のを2つを作成する。
                FactoryBot.create(:event1)
                FactoryBot.create(:event2)
            end

            # イベントが検索できるか
            it "イベントが検索できること" do

                post :search, params: {
                    play: {
                        play_title: "テストタイトル",
                        play_delete_flg: 1  # 0:遊び検索 1:イベント検索
                    }
                }

                # 1件検索ができたか確認する。
                # controller.instance_variable_get("@events") でコントローラ内の変数を見れる。
                expect(controller.instance_variable_get("@events").length).to eq 2

            end

            # 正しくrender先を読み込めているか
            it "render先があっている事" do

                post :search, params: {
                    play: {
                        play_title: "テストタイトル",
                        play_delete_flg: 1  # 0:遊び検索 1:イベント検索
                    }
                }

                # events/index.htmlが呼ばれること
                expect(response).to render_template("events/index")
            end

        end

        

    end


end