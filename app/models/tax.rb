class Tax < ApplicationRecord

    # 空白を不許可にするバリデーション設定
    validates :tax, :tax_start_day, presence: true

    # tax_start_day < 現在時刻 < tax_finish_dayが取得できるか調べる関数
    def tax_start_finish_now?

        # 空の場合、falseを返す
        if self.tax_start_day == nil || self.tax_finish_day == nil
            return false
        end

        # 現在時刻の取得し、日本時間に変換
        time_now_tokyo = DateTime.now.in_time_zone('Tokyo')

        # tax_start_day < 現在時刻 < tax_finish_dayの関係になっているか
        # この書き方はできなかった。
        # self.tax_start_day.in_time_zone('Tokyo') < time_now_tokyo < self.tax_finish_day.in_time_zone('Tokyo')
        if self.tax_start_day.in_time_zone('Tokyo') < time_now_tokyo && time_now_tokyo < self.tax_finish_day.in_time_zone('Tokyo')

            
            return true

        else

            return false

        end

    end


end
