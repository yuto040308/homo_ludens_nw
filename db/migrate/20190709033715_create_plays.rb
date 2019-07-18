class CreatePlays < ActiveRecord::Migration[5.2]
  def change
    create_table :plays do |t|

      # 追加カラム
      t.integer :category_id
      t.string :play_title
      t.text :play_explain
      t.string :play_image_id
      t.integer :play_delete_flg

      # デフォルトで存在
      t.timestamps
    end
  end
end
