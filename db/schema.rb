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

ActiveRecord::Schema.define(version: 20150728170118) do

  create_table "accounts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "sender_id"
    t.integer  "reciever_id"
  end

  add_index "messages", ["reciever_id", "sender_id", "created_at"], name: "index_messages_on_reciever_id_and_sender_id_and_created_at", unique: true
  add_index "messages", ["reciever_id"], name: "index_messages_on_reciever_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

end
