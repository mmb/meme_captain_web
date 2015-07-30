# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150730035705) do

  create_table "captions", force: :cascade do |t|
    t.text     "text"
    t.string   "font"
    t.float    "top_left_x_pct"
    t.float    "top_left_y_pct"
    t.float    "width_pct"
    t.float    "height_pct"
    t.integer  "gend_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "captions", ["gend_image_id"], name: "index_captions_on_gend_image_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "gend_images", force: :cascade do |t|
    t.string   "id_hash"
    t.integer  "src_image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.binary   "image"
    t.integer  "height"
    t.integer  "size"
    t.integer  "width"
    t.boolean  "work_in_progress", default: true
    t.boolean  "is_deleted",       default: false
    t.integer  "user_id"
    t.boolean  "private",          default: false
    t.boolean  "is_animated",      default: false
  end

  add_index "gend_images", ["id_hash"], name: "index_gend_images_on_id_hash", unique: true
  add_index "gend_images", ["is_animated"], name: "index_gend_images_on_is_animated"
  add_index "gend_images", ["is_deleted"], name: "index_gend_images_on_is_deleted"
  add_index "gend_images", ["private"], name: "index_gend_images_on_private"
  add_index "gend_images", ["user_id"], name: "index_gend_images_on_user_id"

  create_table "gend_thumbs", force: :cascade do |t|
    t.string   "content_type"
    t.integer  "gend_image_id"
    t.integer  "height"
    t.binary   "image"
    t.integer  "size"
    t.integer  "width"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gend_thumbs", ["gend_image_id"], name: "index_gend_thumbs_on_gend_image_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "src_images", force: :cascade do |t|
    t.string   "id_hash"
    t.text     "url"
    t.integer  "width"
    t.integer  "height"
    t.integer  "size"
    t.string   "content_type"
    t.binary   "image"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "work_in_progress",  default: true
    t.boolean  "is_deleted",        default: false
    t.text     "name"
    t.boolean  "private",           default: false
    t.integer  "gend_images_count", default: 0,     null: false
    t.boolean  "is_animated",       default: false
  end

  add_index "src_images", ["gend_images_count"], name: "index_src_images_on_gend_images_count"
  add_index "src_images", ["id_hash"], name: "index_src_images_on_id_hash", unique: true
  add_index "src_images", ["is_animated"], name: "index_src_images_on_is_animated"
  add_index "src_images", ["is_deleted"], name: "index_src_images_on_is_deleted"
  add_index "src_images", ["name"], name: "index_src_images_on_name"
  add_index "src_images", ["private"], name: "index_src_images_on_private"

  create_table "src_images_src_sets", id: false, force: :cascade do |t|
    t.integer "src_image_id"
    t.integer "src_set_id"
  end

  add_index "src_images_src_sets", ["src_image_id", "src_set_id"], name: "index_src_images_src_sets_on_src_image_id_and_src_set_id", unique: true

  create_table "src_sets", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted", default: false
    t.integer  "quality",    default: 0,     null: false
  end

  add_index "src_sets", ["is_deleted"], name: "index_src_sets_on_is_deleted"
  add_index "src_sets", ["name"], name: "index_src_sets_on_name"
  add_index "src_sets", ["quality"], name: "index_src_sets_on_quality"
  add_index "src_sets", ["user_id"], name: "index_src_sets_on_user_id"

  create_table "src_thumbs", force: :cascade do |t|
    t.integer  "src_image_id"
    t.integer  "width"
    t.integer  "height"
    t.integer  "size"
    t.binary   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
