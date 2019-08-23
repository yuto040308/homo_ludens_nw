# FactoryBot.define で使用するユーザーをあらかじめ定義しておく
FactoryBot.define do
    factory :tax, class: Tax do
        tax {1.08}
        tax_start_day {DateTime.now.in_time_zone('Tokyo')}
        tax_finish_day {DateTime.new(2050, 10, 10, 17, 00, 00)}
    end
end