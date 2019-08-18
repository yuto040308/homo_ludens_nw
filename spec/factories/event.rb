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

    factory :event, class: Event do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        play_id {1}
        user_id {1}
        event_title {"テストタイトル"}
        event_explain {"テスト説明です"}
        event_image_id {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")}
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

end