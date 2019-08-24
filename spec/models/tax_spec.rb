require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

# モデル名を describeのあとに指定する
RSpec.describe Tax, type: :model do

    # context単位でテストが実施される仕様

    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @tax = Tax.new
            @tax.tax = 1.08
            @tax.tax_start_day = DateTime.new(2010, 10, 10, 10, 00, 00)
            @tax.tax_finish_day = DateTime.new(2055, 11, 11, 11, 00, 00)

            @tax.save
        end
        it "全て入力してあるので保存される" do
            expect(@tax).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "必須項目データが全部空" do
        before do
            @tax = Tax.new
            @tax.tax = nil
            @tax.tax_start_day = nil

            # バリデーションかけていない項目
            @tax.tax_finish_day = DateTime.new(2055, 11, 11, 11, 00, 00)

            @tax.save
        end
        it "バリデーションに引っかかるので保存されない" do
            expect(@tax).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@tax.errors[:tax]).to include("を入力してください")
            expect(@tax.errors[:tax_start_day]).to include("を入力してください")
        end
    end

end