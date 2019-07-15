# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_09_035057) do

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_joins", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "play_id"
    t.integer "user_id"
    t.string "event_title"
    t.text "event_explain"
    t.string "event_image_id"
    t.string "event_place"
    t.integer "event_people_min"
    t.integer "event_people_max"
    t.integer "honorarium"
    t.datetime "event_hold_start_time"
    t.datetime "event_hold_finish_time"
    t.datetime "event_start_time"
    t.datetime "event_finish_time"
    t.integer "event_confirm_flg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plays", force: :cascade do |t|
    t.integer "category_id"
    t.string "play_title"
    t.text "play_explain"
    t.string "play_image_id"
    t.integer "play_delete_flg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.float "tax"
    t.datetime "tax_start_day"
    t.datetime "tax_finish_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_kanji_sei"
    t.string "name_kanji_mei"
    t.string "name_kana_sei"
    t.string "name_kana_mei"
    t.string "nickname"
    t.string "phone_number"
    t.integer "payment_method"
    t.string "user_image_id"
    t.text "user_profile"
    t.integer "admin_flg"
    t.integer "resignation_flg"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
