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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140714031343) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "event_id"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "start"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "uid"
    t.string   "price",       :default => ""
    t.boolean  "published",   :default => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "event_id"
    t.integer  "event_member_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "event_guest_id"
  end

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "action"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "unread",          :default => true
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "notifications", ["notifiable_id", "notifiable_type"], :name => "index_notifications_on_notifiable_id_and_notifiable_type"
  add_index "notifications", ["receiver_id"], :name => "index_notifications_on_receiver_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "role",            :default => "student"
    t.string   "avatar"
    t.text     "bio"
    t.integer  "bean"
    t.text     "freetime"
    t.string   "github_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
