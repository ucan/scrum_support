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

ActiveRecord::Schema.define(:version => 20120919101950) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_member_id"
    t.string   "api_token"
    t.string   "email"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "accounts", ["api_token"], :name => "index_accounts_on_api_token", :unique => true

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

  create_table "external_iteration_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "external_project_link_id"
    t.integer  "iteration_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "external_iteration_links", ["iteration_id", "linked_id"], :name => "index_external_iteration_links_on_iteration_id_and_linked_id", :unique => true

  create_table "external_project_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "external_project_links", ["project_id", "linked_id"], :name => "index_external_project_links_on_project_id_and_linked_id", :unique => true

  create_table "external_story_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "external_iteration_link_id"
    t.integer  "story_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "external_story_links", ["story_id", "linked_id"], :name => "index_external_story_links_on_story_id_and_linked_id", :unique => true

  create_table "external_task_links", :force => true do |t|
    t.integer  "linked_id"
    t.integer  "external_story_link_id"
    t.integer  "task_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "external_task_links", ["task_id", "linked_id"], :name => "index_external_task_links_on_task_id_and_linked_id", :unique => true

  create_table "iterations", :force => true do |t|
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "team_member_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "memberships", ["project_id", "team_member_id"], :name => "index_memberships_on_project_id_and_team_member_id", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "current_iteration_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "stories", :force => true do |t|
    t.integer  "iteration_id"
    t.string   "title"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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

  create_table "team_members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
