require 'rails_helper' # これは書く必要がある
require "refile/file_double" # refileのテストをするため、この記述が必要。
RSpec.describe UsersController, type: :controller do

    describe "マイページ #show" do
        context "マイページが正しく表示される" do
            before do
                # spec/factories/user.rbに定義してあるuserを作成する。
                # user1:イベント主催、user2のイベントに参加もしているユーザー
                # user2:イベント主催しているユーザー
                @user = FactoryBot.create(:user)
                FactoryBot.create(:user2)

                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                # user2主催のイベント作成
                FactoryBot.create(:event2)
                # user1主催のイベント作成
                FactoryBot.create(:event1)

                # user1がuser2のイベントに参加
                FactoryBot.create(:eventjoin)

                # user2がuser1のイベントに参加
                FactoryBot.create(:eventjoin2)

                get :show, params: {id: @user.id }
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end

            it "コントローラ内の変数は正しいか" do
                # 参加イベントが1件検索ができたか確認する。
                expect(controller.instance_variable_get("@event_joins").length).to eq 1
                # 主催イベントが1件検索ができたか確認する。
                expect(controller.instance_variable_get("@events").length).to eq 1
                # 主催イベントの人数が1人か確認する。
                expect(controller.instance_variable_get("@event_counts_array").first).to eq 1
                
            end

        end
    end

    describe "ユーザー編集ページ #edit" do
        context "ユーザー編集ページが正しく表示される" do
            before do
                # ユーザーをログインさせる
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :edit, params: {id: @user.id }
            end

            it "リクエストは200 OKとなること" do
                expect(response.status).to eq 200
            end
        end
    end

    describe "ユーザー更新 #update" do

        # 変更する値をハッシュで定義しておく
        user_param = {
            name_kanji_sei: "変更",
            name_kanji_mei: "二郎",
            name_kana_sei: "ヘンコウ",
            name_kana_mei: "ジロウ",
            nickname: "ジロウくん",
            email: "test2@user",
            password: "12345678",
            phone_number: "09023456789",
            payment_method: 0,
            admin_flg: 1
        }

        context "ユーザーが更新されるか" do
            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                patch :update, params: {id: @user.id, user: user_param}
            end

            it "イベントの内容が書き換わるか" do
                
                # 変更されているか確認 reloadと記入する必要がある
                expect(@user.reload.name_kanji_sei).to eq "変更"
                expect(@user.reload.name_kanji_mei).to eq "二郎"
                expect(@user.reload.name_kana_sei).to eq "ヘンコウ"
                expect(@user.reload.name_kana_mei).to eq "ジロウ"
                expect(@user.reload.nickname).to eq "ジロウくん"
                expect(@user.reload.email).to eq "test2@user"
                expect(@user.reload.password).to eq "12345678"
                expect(@user.reload.phone_number).to eq "09023456789"
                expect(@user.reload.payment_method).to eq 0

            end

            it "リダイレクトされること" do
                # 正常系のリダイレクト先に移動していること
                expect(response).to redirect_to user_path(@user.id)
            end

            it "flash[:notice]にメッセージが含まれているか" do
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq "会員情報更新が完了しました"
            end
        end
    end

    describe "ユーザー退会 #destroy" do
        context "退会出来ること" do
            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user

                delete :destroy, params: {id: @user.id}
            end

            it "退会フラグが立っていること" do
                expect(@user.reload.resignation_flg).to eq 1
            end

            it "リダイレクトされること" do
                # 正常型のリダイレクト先に移動していること
                expect(response).to redirect_to top_path
            end

            it "flash[:notice]にメッセージが含まれているか" do
                # flash[:notice]に想定通りのメッセージが含まれているか
                expect(flash[:notice]).to eq("退会しました")
            end
        end
    end

    describe "主催者情報ページ表示 #event" do
        context "主催者情報ページが正しく表示される" do
            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :event, params: {id: @user.id }
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
    end

    describe "管理者マイページ #admin" do
        context "管理者マイページが正しく表示される" do
            before do
                # userをいろいろ作成
                FactoryBot.create(:user)
                FactoryBot.create(:user2)

                # 遊びを色々作成
                FactoryBot.create(:play1)
                FactoryBot.create(:play2)

                # イベントを色々作成
                FactoryBot.create(:event1)
                FactoryBot.create(:event2)

                # user1がuser2のイベントに参加
                # user2がuser1のイベントに参加
                FactoryBot.create(:eventjoin)
                FactoryBot.create(:eventjoin2)

                # adminでログインする
                @user = FactoryBot.create(:admin_user)
                sign_in @user

                get :admin
            end

            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end

            it "コントローラ内の変数は正しいか" do
                # ユーザーが3件(全件)取得ができたか確認する。
                expect(controller.instance_variable_get("@users").length).to eq 3
                # 遊びが2件(全件)取得ができたか確認する。
                expect(controller.instance_variable_get("@plays").length).to eq 2
                # イベントが2件(全件)取得ができたか確認する。
                expect(controller.instance_variable_get("@events").length).to eq 2
                # 主催イベントの人数が1人か確認する。
                expect(controller.instance_variable_get("@event_counts_array").first).to eq 1
                
            end
        end
    end

    describe "管理者ユーザーページ表示 #admin_show" do
        context "管理者ユーザーページが正しく表示される" do
            before do
                # あらかじめFacrotyBotで登録しておいたユーザーを作成する
                @user = FactoryBot.create(:admin_user)
                # deviseのヘルパー@userをログイン状態にする。
                sign_in @user
                get :admin_show, params: {id: @user.id }
            end

            it "リクエストは200 OKとなること" do
                expect(response.status).to eq 200
            end
        end
    end

end