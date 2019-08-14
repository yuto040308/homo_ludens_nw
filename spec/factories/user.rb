# 複数のfactoryを書く場合は、以下のように、class: User(model)の部分だけを統一し、
# factoryの後ろの:user, :another_userの部分のように、それぞれのfactoryに名前を付けられます。

# FactoryBot.define で使用するユーザーをあらかじめ定義しておく
FactoryBot.define do

    factory :user, class: User do
        # factoryBotの変数は{}の中に記述してあげる必要がある
        name_kanji_sei {"試験"}
        name_kanji_mei {"太郎"}
        name_kana_sei {"シケン"}
        name_kana_mei {"タロウ"}
        nickname {"シケンくん"}
        email {"test@user"}
        password {"12345678"}
        phone_number {"09012345678"}
        payment_method {1}
        admin_flg {0}
    end

    factory :admin_user, class: User do
        name_kanji_sei {"試験"}
        name_kanji_mei {"二郎"}
        name_kana_sei {"シケン"}
        name_kana_mei {"ジロウ"}
        nickname {"ジロウくん"}
        email {"test2@user"}
        password {"12345678"}
        phone_number {"09012345678"}
        payment_method {1}
        admin_flg {1}
    end

end