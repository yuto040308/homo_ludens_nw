require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

RSpec.describe User, type: :model do
    
    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @user = User.new
            @user.name_kanji_sei = "試験"
            @user.name_kanji_mei = "太郎"
            @user.name_kana_sei = "シケン"
            @user.name_kana_mei = "タロウ"
            @user.nickname = "シケンくん"
            @user.email = "tester@test"
            @user.phone_number = "09012345678"
            @user.payment_method = 0
            @user.user_image_id = "fjofwj3jr0suf0fj" # 画像は文字になるので、適当な値を入力
            @user.user_profile = "私は試験太郎です。"
            @user.password = 12345678
            @user.admin_flg = 1
            @user.resignation_flg = 0
            
            @user.save
        end
        it "全て入力してあるので保存される" do
            expect(@user).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "入力データが全部空" do
        before do
            # データ入力
            @user = User.new
            @user.name_kanji_sei = ""
            @user.name_kanji_mei = ""
            @user.name_kana_sei = ""
            @user.name_kana_mei = ""
            @user.nickname = ""
            @user.email = ""
            @user.phone_number = ""

            # この項目はnot nil でないため値はそのまま入れる。
            @user.payment_method = 0
            @user.user_image_id = "fjofwj3jr0suf0fj" # 画像は文字になるので、適当な値を入力
            @user.user_profile = "私は試験太郎です。"

            @user.password = nil

            # この項目はnot nil でないため値はそのまま入れる。
            @user.admin_flg = 1
            @user.resignation_flg = 0
            
            @user.save
        end
        it "バリデーションに引っかかるので保存されない" do
            # 保存失敗することをテスト
            expect(@user).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@user.errors[:name_kanji_sei]).to include("を入力してください")
            expect(@user.errors[:name_kanji_mei]).to include("を入力してください")
            expect(@user.errors[:name_kana_sei]).to include("を入力してください")
            expect(@user.errors[:name_kana_mei]).to include("を入力してください")
            expect(@user.errors[:nickname]).to include("を入力してください")
            expect(@user.errors[:email]).to include("を入力してください")
            expect(@user.errors[:phone_number]).to include("を入力してください")
            expect(@user.errors[:password]).to include("を入力してください")
        end
    end

end