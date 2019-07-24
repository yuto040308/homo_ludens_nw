class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

      # 追加カラム
      t.string :category_name
      

      # デフォルトで存在
      t.timestamps
    end
  end
end
