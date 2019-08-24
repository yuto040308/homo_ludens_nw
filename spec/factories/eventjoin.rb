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

    factory :eventjoin, class: EventJoin do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        event_id {1}
        user_id {1}
    end

    factory :eventjoin2, class: EventJoin do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        event_id {2}
        user_id {2}
    end

end