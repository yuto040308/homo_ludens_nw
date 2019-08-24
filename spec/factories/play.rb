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

    factory :play1, class: Play do
        category_id {1}
        play_title {"テストタイトル"}
        play_explain {"テスト説明です"}
        play_image {Refile::FileDouble.new("dummy", "logo.png", content_type: "image/png")}
        play_delete_flg {0}
    end

    factory :play2, class: Play do
        category_id {2}
        play_title {"テストタイトル2"}
        play_explain {"テスト説明2です"}
        play_image {Refile::FileDouble.new("dummy", "logo2.png", content_type: "image/png")}
        play_delete_flg {0}
    end

end