class Event < ApplicationRecord
    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :event_image

    # イベントが削除された場合は、それに紐づく参加テーブルも削除する。
    has_many :event_joins, :dependent => :destroy

    belongs_to :play, optional: true
    belongs_to :user, optional: true

    # 空白を不許可にするバリデーション設定
    validates :play_id, :user_id, :event_title, :event_explain, :event_place, :event_people_min, :event_people_max,
              :honorarium, :event_hold_start_time, :event_hold_finish_time, :event_start_time, :event_finish_time,
              presence: true

    # 承認フラグの状態をStrging型で戻すメゾット
    def event_confirm_flg_convert

        if self.event_confirm_flg == nil
            return "未承認"
        else
            if self.event_confirm_flg == 0
                return "未承認"
            else
                return "承認済み"
            end
        end

    end

    # 開催開始時刻が現在時刻（日本時間）よりも後か確認する関数
    def event_hold_start_time_now_after?

        # 空かどうか確認
        if self.event_hold_start_time == nil
            return false
        end

        # 現在時刻の取得
        time_now = DateTime.now
        # 現在時刻を日本時刻に変換
        time_now_tokyo = time_now.in_time_zone('Tokyo')

        # 現在時刻(日本時間)を上回っているか
        if self.event_hold_start_time.in_time_zone('Tokyo') > time_now_tokyo
            return true
        else
            return false
        end

    end

    # 開催終了時刻が現在時刻（日本時間）よりも後か確認する関数
    def event_hold_finish_time_now_after?

        # 空かどうか確認
        if self.event_hold_finish_time == nil
            return false
        end

        # 現在時刻の取得
        time_now = DateTime.now
        # 現在時刻を日本時刻に変換
        time_now_tokyo = time_now.in_time_zone('Tokyo')

        # 現在時刻(日本時間)を上回っているか
        if self.event_hold_finish_time.in_time_zone('Tokyo') > time_now_tokyo
            return true
        else
            return false
        end

    end

    # 募集開始時刻が現在時刻（日本時間）よりも後か確認する関数
    def event_start_time_now_after?

        # 空かどうか確認
        if self.event_start_time == nil
            return false
        end

        # 現在時刻の取得
        time_now = DateTime.now
        # 現在時刻を日本時刻に変換
        time_now_tokyo = time_now.in_time_zone('Tokyo')

        # 現在時刻(日本時間)を上回っているか
        if self.event_start_time.in_time_zone('Tokyo') > time_now_tokyo
            return true
        else
            return false
        end

    end

    # 募集終了時刻が現在時刻（日本時間）よりも後か確認する関数
    def event_finish_time_now_after?

        # 空かどうか確認
        if self.event_finish_time == nil
            return false
        end

        # 現在時刻の取得
        time_now = DateTime.now
        # 現在時刻を日本時刻に変換
        time_now_tokyo = time_now.in_time_zone('Tokyo')

        # 現在時刻(日本時間)を上回っているか
        if self.event_finish_time.in_time_zone('Tokyo') > time_now_tokyo
            return true
        else
            return false
        end

    end

    # 開催開始時刻 < 開催終了時刻 で成り立っているか確認する関数
    def event_hold_time_from_to?
        
        # 空かどうか確認
        if self.event_hold_start_time == nil || self.event_hold_finish_time == nil
            return false
        end

        if self.event_hold_start_time < self.event_hold_finish_time
            return true
        else
            return false
        end
    end

    # イベント募集開始時刻 < イベント募集終了時刻 で成り立っているか確認する関数
    def event_collect_time_from_to?

        # 空かどうか確認
        if self.event_start_time == nil || self.event_finish_time == nil
            return false
        end

        if self.event_start_time < self.event_finish_time
            return true
        else
            return false
        end
    end

    # 募集終了時刻がイベント開始時刻より前か確認する関数
    def event_collect_hold_time?

        # 空かどうか確認
        if self.event_finish_time == nil || self.event_hold_start_time == nil
            return false
        end

        if self.event_finish_time < self.event_hold_start_time
            return true
        else
            return false
        end

    end

    # 最小催行人数<最大催行人数の関係を確認する関数
    def event_join_peoples_min_max?

        # 空かどうか確認
        if self.event_people_min == nil || self.event_people_max == nil
            return false
        end

        if self.event_people_min <= self.event_people_max
            return true
        else
            return false
        end

    end

    # 入力必須項目があるかチェックする関数
    def essential_params_check?
        # text_fieldsは何も入れないとき、nilではなく、空白が入る仕様みたい。
        if self.event_title == nil || self.event_explain == "" || self.event_place == "" || 
           self.event_people_min == nil || event_people_max == nil || self.honorarium == nil ||
           self.event_hold_start_time == nil || self.event_hold_finish_time == nil || self.event_start_time == nil ||
           self.event_finish_time == nil

            return false
        else
            return true
        end
    end

    # 保存前に整合性を確認し、Arrayクラスにエラーをpushして最後にsave可否を返す
    # @付きの変数は渡せないみたい。@event → eventにすると渡せた。
    def event_save_before_check?(array)

        save_flg = 1

        if self.event_hold_start_time_now_after? == false
        array.push("イベント開始時刻を、現在時刻よりも後に入力してください。")
        save_flg = 0
        end

        if self.event_hold_finish_time_now_after? == false
        array.push("イベント終了時刻を、現在時刻よりも後に入力してください。")
        save_flg = 0
        end

        if self.event_start_time_now_after? == false
        array.push("イベント募集開始時刻を、現在時刻よりも後に入力してください。")
        save_flg = 0
        end

        if self.event_finish_time_now_after? == false
        array.push("イベント募集終了時刻を、現在時刻よりも後に入力してください。")
        save_flg = 0
        end

        if self.event_hold_time_from_to? == false
        array.push("募集開始時刻が、募集終了時刻よりも前になっていません。")
        save_flg = 0
        end

        if self.event_collect_time_from_to? == false
        array.push("イベント開始時刻が、イベント終了時刻よりも前になっていません。")
        save_flg = 0
        end

        # イベント開始時刻 > 募集終了時刻になっているか確認。
        if self.event_collect_hold_time? == false
        array.push("募集終了時刻が、イベント開始時刻よりも前になっていません。")
        save_flg = 0
        end

        # 最小催行人数<最大催行人数になっているかチェックする
        if self.event_join_peoples_min_max? == false
        array.push("最大催行人数は、最小催行人数以上で入力してください")
        save_flg = 0
        end

        if save_flg == 1
            return true
        else
            return false
        end

    end

    # 募集開始時刻 < 現在時刻 < 募集終了時刻の関係性が成り立つか確認する関数
    def collect_start_now_finish?
        
        # 現在時刻の取得（日本時間）
        time_now_tokyo = DateTime.now.in_time_zone('Tokyo')

        # 現在時刻が開始時刻以上で、終了時刻未満か
        if time_now_tokyo >= self.event_start_time.in_time_zone('Tokyo') &&
           time_now_tokyo <  self.event_finish_time.in_time_zone('Tokyo')
            return true
        else
            return false
        end

    end

end
