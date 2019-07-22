class HomeController < ApplicationController
  def top
    # top画面だけ、ヘッダーを背景に透過させるので、判別する変数を渡す。
    @top_flg = 1
  end

  # jQuery動作テスト用
  def test
  end

end
