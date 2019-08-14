class EventJoin < ApplicationRecord
    belongs_to :event, optional: true

    # 空白を不許可にするバリデーション設定
    validates :event_id, :user_id, presence: true
end
