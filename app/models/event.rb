class Event < ApplicationRecord
    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :event_image

    # イベントが削除された場合は、それに紐づく参加テーブルも削除する。
    has_many :event_joins, :dependent => :destroy

    belongs_to :play, optional: true
    belongs_to :user, optional: true

    # 空白を不許可にするバリデーション設定
    validates :event_title, :event_explain, :event_place, :event_people_min, :event_people_max,
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
        if self.event_hold_start_time < self.event_hold_finish_time
            return true
        else
            return false
        end
    end

    # イベント募集開始時刻 < イベント募集終了時刻 で成り立っているか確認する関数
    def event_hold_time_from_to?
        if self.event_start_time < self.event_finish_time
            return true
        else
            return false
        end
    end

    # 募集終了時刻がイベント開始時刻より前か確認する関数
    def event_collect_hold_time?
        if self.event_finish_time < self.event_hold_start_time
            return true
        else
            return false
        end

    end

end
