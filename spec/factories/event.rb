# 複数のfactoryを書く場合は、以下のように、class: User(model)の部分だけを統一し、
# factoryの後ろの:user, :another_userの部分のように、それぞれのfactoryに名前を付けられます。

# FactoryBotはgemでinstallしないと動かない
# group :test do
#   gem 'factory_bot_rails'
#   gem 'database_cleaner'
# end
#


# FactoryBot.define で使用するユーザーをあらかじめ定義しておく
FactoryBot.define do

    factory :event1, class: Event do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        play_id {1}
        user_id {1}
        event_title {"テストタイトル"}
        event_explain {"テスト説明です"}
        event_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")} #_idは消す
        event_place {"テスト場所"}
        event_people_min {5}
        event_people_max {10}
        honorarium {10000}
        event_hold_start_time {DateTime.new(2050, 10, 10, 10, 00, 00)}
        event_hold_finish_time {DateTime.new(2050, 10, 10, 17, 00, 00)}
        event_start_time {DateTime.new(2049, 11, 11, 10, 00, 00)}
        event_finish_time {DateTime.new(2050, 9, 20, 10, 00, 00)}
        event_confirm_flg {1}
    end

    factory :event2, class: Event do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        play_id {2}
        user_id {2}
        event_title {"テストタイトル"}
        event_explain {"テスト2説明です"}
        event_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")}
        event_place {"テスト場所2"}
        event_people_min {10}
        event_people_max {20}
        honorarium {12000}
        event_hold_start_time {DateTime.new(2051, 10, 10, 10, 00, 00)}
        event_hold_finish_time {DateTime.new(2051, 10, 10, 17, 00, 00)}
        event_start_time {DateTime.new(2050, 11, 11, 10, 00, 00)}
        event_finish_time {DateTime.new(2051, 9, 20, 10, 00, 00)}
        event_confirm_flg {1}
    end

    # 募集時間が現時刻から始まっているイベント
    factory :event3, class: Event do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        play_id {2}
        user_id {2}
        event_title {"テストタイトル"}
        event_explain {"テスト3説明です"}
        event_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")}
        event_place {"テスト場所3"}
        event_people_min {10}
        event_people_max {20}
        honorarium {12000}
        event_hold_start_time {DateTime.new(2051, 10, 10, 10, 00, 00)}
        event_hold_finish_time {DateTime.new(2051, 10, 10, 17, 00, 00)}
        event_start_time {DateTime.now.in_time_zone('Tokyo')}
        event_finish_time {DateTime.new(2051, 9, 20, 10, 00, 00)}
        event_confirm_flg {1}
    end

    # admin_accept で使用を想定 承認フラグは初期値:0
    factory :event4, class: Event do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        play_id {1}
        user_id {1}
        event_title {"テストタイトル"}
        event_explain {"テスト説明です"}
        event_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")} #_idは消す
        event_place {"テスト場所"}
        event_people_min {5}
        event_people_max {10}
        honorarium {10000}
        event_hold_start_time {DateTime.new(2050, 10, 10, 10, 00, 00)}
        event_hold_finish_time {DateTime.new(2050, 10, 10, 17, 00, 00)}
        event_start_time {DateTime.new(2049, 11, 11, 10, 00, 00)}
        event_finish_time {DateTime.new(2050, 9, 20, 10, 00, 00)}
        event_confirm_flg {0}
    end

end