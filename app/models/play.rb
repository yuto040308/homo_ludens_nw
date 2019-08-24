class Play < ApplicationRecord

    # refileでattachment_fieldを使う場合、ここに指定しないと動かない _idは外す
    attachment :play_image

    # 遊びが削除された場合は、それに紐づくイベントも削除する。
    has_many :events, :dependent => :destroy
    
    belongs_to :category, optional: true

    # 遊びタイトル、遊び説明分の空白を不許可にするバリデーション設定
    validates :category_id, :play_title, :play_explain, presence: true


end
