require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

# モデル名を describeのあとに指定する
RSpec.describe Category, type: :model do

    # context単位でテストが実施される仕様

    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @category = Category.new
            @category.category_name = "テストカテゴリ"

            @category.save
        end
        it "全て入力してあるので保存される" do
            expect(@category).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "必須項目データが全部空" do
        before do
            @category = Category.new
            @category.category_name = ""

            @category.save
        end
        it "バリデーションに引っかかるので保存されない" do
            expect(@category).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@category.errors[:category_name]).to include("を入力してください")
        end
    end

end