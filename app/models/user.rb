class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  attachment :user_image

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
