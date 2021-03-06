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

ActiveRecord::Schema.define(version: 20171008065302) do

  create_table "book_notifications", force: :cascade do |t|
    t.string   "book"
    t.string   "categoryPaths"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "newsletter_id"
  end

  add_index "book_notifications", ["newsletter_id"], name: "index_book_notifications_on_newsletter_id"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "categoryCodes"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "code"
    t.string   "title"
    t.string   "superCategoryCode"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "parent_id"
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "subscriber_id"
    t.integer  "category_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "interests", ["category_id"], name: "index_interests_on_category_id"
  add_index "interests", ["subscriber_id"], name: "index_interests_on_subscriber_id"

  create_table "listings", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "listings", ["book_id"], name: "index_listings_on_book_id"
  add_index "listings", ["category_id"], name: "index_listings_on_category_id"

  create_table "newsletters", force: :cascade do |t|
    t.string   "recipient"
    t.integer  "subscriber_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "notifications"
  end

  add_index "newsletters", ["subscriber_id"], name: "index_newsletters_on_subscriber_id"

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "categoryCodes"
  end

end
