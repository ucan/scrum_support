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

ActiveRecord::Schema.define(:version => 20120630130107) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "api_token"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "accounts_external_project_links", :force => true do |t|
    t.integer "account_id"
    t.integer "external_project_link_id"
  end

  create_table "api_keys", :force => true do |t|
    t.string   "auth_token"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "api_keys", ["auth_token"], :name => "index_api_keys_on_auth_token", :unique => true

  create_table "external_project_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "external_project_links", ["project_id", "linked_id"], :name => "index_external_project_links_on_project_id_and_linked_id", :unique => true

  create_table "external_story_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "external_project_link_id"
    t.integer  "story_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "external_task_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "external_story_link_id"
    t.integer  "task_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["project_id", "person_id"], :name => "index_memberships_on_project_id_and_person_id", :unique => true

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stories", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.string   "status"
    t.integer  "story_id"
    t.integer  "owner_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tasks", ["story_id"], :name => "index_tasks_on_story_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
