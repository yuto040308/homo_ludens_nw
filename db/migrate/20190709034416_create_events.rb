class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, :options => 'ENGINE=InnoDB ROW_FORMAT=DYNAMIC' do |t|

      # 追加カラム
      t.integer :play_id
      t.integer :user_id
      t.string :event_title
      t.text :event_explain
      t.string :event_image_id
      t.string :event_place
      t.integer :event_people_min
      t.integer :event_people_max
      t.integer :honorarium
      t.datetime :event_hold_start_time
      t.datetime :event_hold_finish_time
      t.datetime :event_start_time
      t.datetime :event_finish_time
      t.integer :event_confirm_flg

      # デフォルトで存在
      t.timestamps
    end
  end
end
