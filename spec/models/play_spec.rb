require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

RSpec.describe Play, type: :model do

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

end