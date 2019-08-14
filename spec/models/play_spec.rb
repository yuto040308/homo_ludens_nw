require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

RSpec.describe Play, type: :model do

    # context単位でテストが実施される仕様

    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @play = Play.new
            @play.category_id = 1
            @play.play_title = "テストタイトル"
            @play.play_explain = "テスト説明です"
            @play.play_image_id = "fjwoewjfiowjifel"   # 画像は文字になるので、適当な値を入力
            @play.play_delete_flg = 1
            
            @play.save
        end
        it "全て入力してあるので保存される" do
            expect(@play).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "必須項目データが全部空" do
        before do
            # データ入力
            @play = Play.new

            @play.category_id = nil
            @play.play_title = ""
            @play.play_explain = ""

            # このカラム達は必須項目でない
            @play.play_image_id = "fjwoewjfiowjifel"   # 画像は文字になるので、適当な値を入力
            @play.play_delete_flg = 1
            
            @play.save
        end
        it "バリデーションに引っかかるので保存されない" do
            # 保存失敗することをテスト
            expect(@play).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@play.errors[:category_id]).to include("を入力してください")
            expect(@play.errors[:play_title]).to include("を入力してください")
            expect(@play.errors[:play_explain]).to include("を入力してください")
            
        end
    end

end