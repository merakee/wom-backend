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

ActiveRecord::Schema.define(version: 20150205214630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment_responses", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "comment_id", limit: 8
    t.boolean  "response",             default: false, null: false
    t.datetime "created_at"
  end

  add_index "comment_responses", ["comment_id"], name: "index_comment_responses_on_comment_id", using: :btree
  add_index "comment_responses", ["user_id"], name: "index_comment_responses_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id",        limit: 8
    t.integer  "content_id",     limit: 8
    t.text     "text",                     default: "", null: false
    t.integer  "like_count",               default: 0,  null: false
    t.integer  "new_like_count",           default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["content_id"], name: "index_comments_on_content_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "content_categories", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_flags", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "content_id", limit: 8
    t.datetime "created_at"
  end

  create_table "contents", force: true do |t|
    t.integer  "user_id",             limit: 8
    t.integer  "content_category_id"
    t.text     "text",                          default: "",  null: false
    t.string   "photo_token",                   default: "",  null: false
    t.integer  "total_spread",                  default: 0,   null: false
    t.integer  "spread_count",                  default: 0,   null: false
    t.integer  "kill_count",                    default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "freshness_factor",              default: 1.0, null: false
    t.float    "spread_efficiency",             default: 1.0, null: false
    t.float    "spread_index",                  default: 1.0, null: false
    t.integer  "comment_count",                 default: 0,   null: false
    t.integer  "flag_count",                    default: 0,   null: false
    t.integer  "new_comment_count",             default: 0,   null: false
  end

  add_index "contents", ["spread_index"], name: "index_contents_on_spread_index", using: :btree
  add_index "contents", ["user_id"], name: "index_contents_on_user_id", using: :btree

  create_table "favorite_contents", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "content_id", limit: 8
    t.datetime "created_at"
  end

  add_index "favorite_contents", ["content_id"], name: "index_favorite_contents_on_content_id", using: :btree
  add_index "favorite_contents", ["user_id"], name: "index_favorite_contents_on_user_id", using: :btree

  create_table "user_ratings", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "content_id", limit: 8
    t.float    "rating",               default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_ratings", ["content_id"], name: "index_user_ratings_on_content_id", using: :btree
  add_index "user_ratings", ["user_id"], name: "index_user_ratings_on_user_id", using: :btree

  create_table "user_responses", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "content_id", limit: 8
    t.boolean  "response",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_responses", ["content_id"], name: "index_user_responses_on_content_id", using: :btree
  add_index "user_responses", ["user_id"], name: "index_user_responses_on_user_id", using: :btree

  create_table "user_types", force: true do |t|
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",           null: false
    t.string   "encrypted_password",     default: "",           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.integer  "user_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname",               default: "Anonymous",  null: false
    t.string   "avatar",                 default: "avatar.jpg", null: false
    t.text     "bio",                    default: " ",          null: false
    t.string   "social_tags",            default: [],           null: false, array: true
    t.string   "hometown",               default: " ",          null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comment_responses", "comments", name: "comment_responses_comment_id_fk", dependent: :delete
  add_foreign_key "comment_responses", "users", name: "comment_responses_user_id_fk", dependent: :delete

  add_foreign_key "comments", "contents", name: "comments_content_id_fk", dependent: :delete
  add_foreign_key "comments", "users", name: "comments_user_id_fk", dependent: :delete

  add_foreign_key "contents", "users", name: "contents_user_id_fk", dependent: :delete

  add_foreign_key "user_responses", "contents", name: "user_responses_content_id_fk", dependent: :delete
  add_foreign_key "user_responses", "users", name: "user_responses_user_id_fk", dependent: :delete

end
