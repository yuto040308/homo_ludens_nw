class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  attachment :user_image

  # 外国人ユーザーも想定し、漢字名、性を漢字のみにしない
  validates :name_kanji_sei, :name_kanji_mei, :nickname,
            presence: true

  # 電話番号はハイフン入力を不許可にする。
  # formatは最後に書かないとエラーになる。
  validates :phone_number, length: { in: 8..11 }, presence: true, format: { with: /\A[0-9]+\z/ }

  # 正規表現で、カナの入力のみ許可
  validates :name_kana_sei, :name_kana_mei, presence: true, format: { with: /\A[ァ-ヶー－]+\Z/ }

  # 退会状態フラグの状態をString型のメッセージで返す関数
  def resignation_flg_message
    if self.resignation_flg == nil
      return "　"
    else
      if self.resignation_flg == 0
          return "　"
      else
          return "退会済み"
      end
    end
  end

  # 支払方法の状態をString型のメッセージで返す関数
  def payment_method_message

    if self.payment_method == nil
      return "　"
    else
      if self.payment_method == 0
          return "銀行口座"
      else
          return "クレジットカード"
      end
    end

  end

end
