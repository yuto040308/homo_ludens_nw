require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

# モデル名を describeのあとに指定する
RSpec.describe EventJoin, type: :model do

    # context単位でテストが実施される仕様

    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @eventjoin = EventJoin.new
            @eventjoin.event_id = 1
            @eventjoin.user_id = 2


            @eventjoin.save
        end
        it "全て入力してあるので保存される" do
            expect(@eventjoin).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "必須項目データが全部空" do
        before do
            @eventjoin = EventJoin.new
            @eventjoin.event_id = nil
            @eventjoin.user_id = nil


            @eventjoin.save
        end
        it "バリデーションに引っかかるので保存されない" do
            expect(@eventjoin).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@eventjoin.errors[:event_id]).to include("を入力してください")
            expect(@eventjoin.errors[:user_id]).to include("を入力してください")
        end
    end

end