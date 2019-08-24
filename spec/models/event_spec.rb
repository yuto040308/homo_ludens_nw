require 'rails_helper' # これは書く必要がある

# モデル名_spec.rb で名前を付けるルール

# モデル名を describeのあとに指定する
RSpec.describe Event, type: :model do

    # context単位でテストが実施される仕様

    #
    # モデルにデータが正しく保存されるかテストする。
    #
    context "入力項目全てのデータが正しく保存される" do
        before do
            @event = Event.new
            @event.play_id = 1
            @event.user_id = 1
            @event.event_title = "テストタイトル"
            @event.event_explain = "テスト説明です"
            @event.event_image_id = "fjwoewjfiowjifel"   # 画像は文字になるので、適当な値を入力
            @event.event_place = "テスト場所"
            @event.event_people_min = 5
            @event.event_people_max = 10
            @event.honorarium = 10000
            @event.event_hold_start_time = DateTime.new(2050, 10, 10, 10, 00, 00)
            @event.event_hold_finish_time = DateTime.new(2050, 10, 10, 17, 00, 00)
            @event.event_start_time = DateTime.new(2049, 11, 11, 10, 00, 00)
            @event.event_finish_time = DateTime.new(2050, 9, 20, 10, 00, 00)
            @event.event_confirm_flg = 1

            @event.save
        end
        it "全て入力してあるので保存される" do
            expect(@event).to be_valid
        end
    end

    #
    # nilの値で保存されない事を確認する。
    #
    context "必須項目データが全部空" do
        before do
            @event = Event.new
            @event.play_id = nil
            @event.user_id = nil
            @event.event_title = ""
            @event.event_explain = ""

            # このカラムは必須項目でない
            @event.event_image_id = "fjwoewjfiowjifel"   # 画像は文字になるので、適当な値を入力

            @event.event_place = ""
            @event.event_people_min = nil
            @event.event_people_max = nil
            @event.honorarium = nil
            @event.event_hold_start_time = nil
            @event.event_hold_finish_time = nil
            @event.event_start_time = nil
            @event.event_finish_time = nil

            # このカラムは必須項目でない
            @event.event_confirm_flg = 1

            @event.save
        end
        it "バリデーションに引っかかるので保存されない" do
            # 保存失敗することをテスト
            expect(@event).to be_invalid
            # エラー文を日本語化しているため、can't be blank → を入力してくださいと書き直した。
            expect(@event.errors[:play_id]).to include("を入力してください")
            expect(@event.errors[:user_id]).to include("を入力してください")
            expect(@event.errors[:event_title]).to include("を入力してください")
            expect(@event.errors[:event_explain]).to include("を入力してください")
            expect(@event.errors[:event_place]).to include("を入力してください")
            expect(@event.errors[:event_people_min]).to include("を入力してください")
            expect(@event.errors[:event_people_max]).to include("を入力してください")
            expect(@event.errors[:honorarium]).to include("を入力してください")
            expect(@event.errors[:event_hold_start_time]).to include("を入力してください")
            expect(@event.errors[:event_hold_finish_time]).to include("を入力してください")
            expect(@event.errors[:event_start_time]).to include("を入力してください")
            expect(@event.errors[:event_finish_time]).to include("を入力してください")
            
        end
    end

end