require 'rails_helper' # これは書く必要がある
RSpec.describe PlaysController, type: :controller do
    describe '遊び一覧ページ' do
      context "遊び一覧ページが正しく表示される" do

        before do
          get :index
        end

        it 'リクエストは200 OKとなること' do
          expect(response.status).to eq 200
        end
      end
    end

    describe '遊び詳細ページ' do
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

    describe '管理者用遊び詳細ページ' do
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


end