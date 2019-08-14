class Category < ApplicationRecord
    has_many :plays

    # 空白を不許可にするバリデーション設定
    validates :category_name, presence: true
end
