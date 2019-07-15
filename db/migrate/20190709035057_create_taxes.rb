class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|

      # 追加カラム
      t.float :tax
      t.datetime :tax_start_day
      t.datetime :tax_finish_day

      # デフォルトで存在
      t.timestamps
    end
  end
end
