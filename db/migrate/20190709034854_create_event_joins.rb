class CreateEventJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :event_joins, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

      # 追加カラム
      t.integer :event_id
      t.integer :user_id

      # デフォルトで存在
      t.timestamps
    end
  end
end
