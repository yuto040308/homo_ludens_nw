class Event < ApplicationRecord
    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :event_image

    has_many :event_joins

    belongs_to :play, optional: true
    belongs_to :user, optional: true

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
end
