require 'rails_helper' # これは書く必要がある
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
                            play_image_id: "fjwoewjfiowjifel",  # 画像は文字になるので、適当な値を入力
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
                            play_image_id: "fjwoewjfiowjifel",  # 画像は文字になるので、適当な値を入力
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


end